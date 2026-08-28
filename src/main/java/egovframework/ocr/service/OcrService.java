package egovframework.ocr.service;

import org.springframework.stereotype.Service;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.UUID;

@Service
public class OcrService {

    private static final String API_URL = "https://jllp93zoyi.apigw.ntruss.com/custom/v1/53268/39d3f3275508a1b129280c3f0215106087926a316c46c826cfdad6547e237a12/general";
    private static final String SECRET_KEY = System.getenv("CLOVA_OCR_SECRET");
    public String callClovaOcr(byte[] imageBytes, String fileName) throws Exception {
        URL url = new URL(API_URL);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setUseCaches(false);
        con.setDoInput(true);
        con.setDoOutput(true);
        con.setReadTimeout(30000);
        con.setRequestMethod("POST");

        String boundary = "----" + UUID.randomUUID().toString().replaceAll("-", "");
        con.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
        con.setRequestProperty("X-OCR-SECRET", SECRET_KEY);

        String message = "{\"version\":\"V2\","
            + "\"requestId\":\"" + UUID.randomUUID() + "\","
            + "\"timestamp\":" + System.currentTimeMillis() + ","
            + "\"lang\":\"ko\","
            + "\"images\":[{\"format\":\"jpg\",\"name\":\"receipt\"}]}";

        try (DataOutputStream wr = new DataOutputStream(con.getOutputStream())) {
            writeMultipartText(wr, boundary, "message", message);
            writeMultipartFile(wr, boundary, "file", fileName, imageBytes);
            wr.writeBytes("--" + boundary + "--\r\n");
        }

        int responseCode = con.getResponseCode();
        InputStream is = responseCode == 200 ? con.getInputStream() : con.getErrorStream();
        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
        }
        return response.toString();
    }

    private void writeMultipartText(DataOutputStream wr, String boundary,
            String name, String value) throws Exception {
        wr.writeBytes("--" + boundary + "\r\n");
        wr.writeBytes("Content-Disposition: form-data; name=\"" + name + "\"\r\n\r\n");
        wr.write(value.getBytes("UTF-8"));
        wr.writeBytes("\r\n");
    }

    private void writeMultipartFile(DataOutputStream wr, String boundary,
            String name, String fileName, byte[] fileBytes) throws Exception {
        wr.writeBytes("--" + boundary + "\r\n");
        wr.writeBytes("Content-Disposition: form-data; name=\"" + name
            + "\"; filename=\"" + fileName + "\"\r\n");
        wr.writeBytes("Content-Type: application/octet-stream\r\n\r\n");
        wr.write(fileBytes);
        wr.writeBytes("\r\n");
    }
}
