package egovframework.supplier.vo;

public class SupplierVO {
    private Long   supplierId;
    private String supplierName;
    private String contact;
    private String phone;
    private String address;
    private int    isActive;

    // 검색 조건
    private String searchKeyword;
    private String searchActive;

    public Long   getSupplierId()                { return supplierId; }
    public void   setSupplierId(Long v)          { this.supplierId = v; }
    public String getSupplierName()              { return supplierName; }
    public void   setSupplierName(String v)      { this.supplierName = v; }
    public String getContact()                   { return contact; }
    public void   setContact(String v)           { this.contact = v; }
    public String getPhone()                     { return phone; }
    public void   setPhone(String v)             { this.phone = v; }
    public String getAddress()                   { return address; }
    public void   setAddress(String v)           { this.address = v; }
    public int    getIsActive()                  { return isActive; }
    public void   setIsActive(int v)             { this.isActive = v; }
    public String getSearchKeyword()             { return searchKeyword; }
    public void   setSearchKeyword(String v)     { this.searchKeyword = v; }
    public String getSearchActive()              { return searchActive; }
    public void   setSearchActive(String v)      { this.searchActive = v; }
}
