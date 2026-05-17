package egovframework.salary.vo;

public class SalaryVO {
    private int    salaryId;
    private String memberId;
    private String name;
    private String department;
    private String position;
    private int    baseSalary;
    private int    payYear;
    private int    payMonth;
    private String createdAt;

    public int    getSalaryId()                  { return salaryId; }
    public void   setSalaryId(int salaryId)      { this.salaryId = salaryId; }
    public String getMemberId()                  { return memberId; }
    public void   setMemberId(String memberId)   { this.memberId = memberId; }
    public String getName()                      { return name; }
    public void   setName(String name)           { this.name = name; }
    public String getDepartment()                { return department; }
    public void   setDepartment(String d)        { this.department = d; }
    public String getPosition()                  { return position; }
    public void   setPosition(String position)   { this.position = position; }
    public int    getBaseSalary()                { return baseSalary; }
    public void   setBaseSalary(int baseSalary)  { this.baseSalary = baseSalary; }
    public int    getPayYear()                   { return payYear; }
    public void   setPayYear(int payYear)        { this.payYear = payYear; }
    public int    getPayMonth()                  { return payMonth; }
    public void   setPayMonth(int payMonth)      { this.payMonth = payMonth; }
    public String getCreatedAt()                 { return createdAt; }
    public void   setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
