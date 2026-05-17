package egovframework.customer.vo;

public class CustomerVO {
    private Long   customerId;
    private String customerName;
    private String contact;
    private String phone;
    private String address;
    private int    isActive;

    public Long   getCustomerId()              { return customerId; }
    public void   setCustomerId(Long v)        { this.customerId = v; }
    public String getCustomerName()            { return customerName; }
    public void   setCustomerName(String v)    { this.customerName = v; }
    public String getContact()                 { return contact; }
    public void   setContact(String v)         { this.contact = v; }
    public String getPhone()                   { return phone; }
    public void   setPhone(String v)           { this.phone = v; }
    public String getAddress()                 { return address; }
    public void   setAddress(String v)         { this.address = v; }
    public int    getIsActive()                { return isActive; }
    public void   setIsActive(int v)           { this.isActive = v; }
}