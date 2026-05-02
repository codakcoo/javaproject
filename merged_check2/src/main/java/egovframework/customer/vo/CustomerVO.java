// ============================================================
// CustomerVO.java — egovframework.customer.vo
// ============================================================
package egovframework.customer.vo;

public class CustomerVO {
    private Long    customerId;
    private String  customerName;
    private String  contact;
    private String  phone;
    private String  address;
    private Integer isActive;
    private String  keyword;

    public Long    getCustomerId()    { return customerId; }
    public void    setCustomerId(Long customerId) { this.customerId = customerId; }
    public String  getCustomerName()  { return customerName; }
    public void    setCustomerName(String customerName) { this.customerName = customerName; }
    public String  getContact()       { return contact; }
    public void    setContact(String contact) { this.contact = contact; }
    public String  getPhone()         { return phone; }
    public void    setPhone(String phone) { this.phone = phone; }
    public String  getAddress()       { return address; }
    public void    setAddress(String address) { this.address = address; }
    public Integer getIsActive()      { return isActive; }
    public void    setIsActive(Integer isActive) { this.isActive = isActive; }
    public String  getKeyword()       { return keyword; }
    public void    setKeyword(String keyword) { this.keyword = keyword; }
}
