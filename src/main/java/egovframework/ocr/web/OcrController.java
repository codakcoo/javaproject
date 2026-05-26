package egovframework.ocr.web;

import egovframework.member.vo.MemberVO;
import egovframework.ocr.service.OcrService;
import egovframework.order.mapper.OrderReceiptMapper;
import egovframework.order.vo.OrderReceiptItemVO;
import egovframework.order.vo.OrderReceiptVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.PDFRenderer;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.ByteArrayOutputStream;

@Controller
@RequestMapping("/ocr")
public class OcrController {

    @Autowired private OcrService ocrService;
    @Autowired private OrderReceiptMapper orderReceiptMapper;

    @GetMapping("/upload.do")
    public String ocrUploadForm(HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        return "ocr/ocrUpload";
    }

    @PostMapping("/upload.do")
    @ResponseBody
    public String ocrUpload(
            @RequestParam("imageFile") MultipartFile imageFile,
            HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "UNAUTHORIZED";
        try {
            String fileName = imageFile.getOriginalFilename();
            byte[] imageBytes;

            if (fileName != null && fileName.toLowerCase().endsWith(".pdf")) {
                imageBytes = convertPdfToImage(imageFile.getBytes());
                fileName = fileName.replace(".pdf", ".jpg");
            } else {
                imageBytes = imageFile.getBytes();
            }

            return ocrService.callClovaOcr(imageBytes, fileName);
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }

    @PostMapping("/preview.do")
    @ResponseBody
    public String pdfPreview(
            @RequestParam("imageFile") MultipartFile imageFile,
            HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "UNAUTHORIZED";
        try {
            byte[] imgBytes = convertPdfToImage(imageFile.getBytes());
            return java.util.Base64.getEncoder().encodeToString(imgBytes);
        } catch (Exception e) {
            return "ERROR";
        }
    }

    private byte[] convertPdfToImage(byte[] pdfBytes) throws Exception {
        try (PDDocument doc = PDDocument.load(pdfBytes)) {
            PDFRenderer renderer = new PDFRenderer(doc);
            BufferedImage image = renderer.renderImageWithDPI(0, 300);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(image, "jpg", baos);
            return baos.toByteArray();
        }
    }

    @PostMapping("/saveOrder.do")
    @ResponseBody
    public String saveOrder(
            @RequestBody Map<String, Object> body,
            HttpSession session) {

        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) return "UNAUTHORIZED";

        try {
            String receiptNo = "OCR-" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());

            OrderReceiptVO receipt = new OrderReceiptVO();
            receipt.setReceiptNo(receiptNo);
            receipt.setDocType((String) body.get("docType"));
            receipt.setPartnerName((String) body.get("partnerName"));
            receipt.setRequesterId(loginUser.getMemberId());
            receipt.setTotalAmount(parseDouble(body.get("totalAmount")));
            receipt.setDocId(null);

            orderReceiptMapper.insertReceipt(receipt);
            Long receiptId = receipt.getReceiptId();

            List<Map<String, Object>> items = (List<Map<String, Object>>) body.get("items");
            if (items != null) {
                for (Map<String, Object> item : items) {
                    OrderReceiptItemVO itemVO = new OrderReceiptItemVO();
                    itemVO.setReceiptId(receiptId);
                    itemVO.setProductName((String) item.get("productName"));
                    itemVO.setProductCode("-");
                    itemVO.setUnit("EA");
                    itemVO.setQty(parseDouble(item.get("qty")));
                    itemVO.setUnitCost(parseDouble(item.get("unitCost")));
                    itemVO.setAmount(parseDouble(item.get("amount")));
                    orderReceiptMapper.insertReceiptItem(itemVO);
                }
            }
            return "OK:" + receiptId;
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }

    private double parseDouble(Object val) {
        if (val == null) return 0;
        try { return Double.parseDouble(val.toString().replace(",", "")); }
        catch (Exception e) { return 0; }
    }
}
