package egovframework.dept.vo;

public class DeptVO {
    private String deptId;      // 부서 코드
    private String deptName;    // 부서명
    private String managerId;   // 부서장 아이디
    private String managerName; // 부서장 이름 (JOIN용)
    private int    empCount;    // 소속 직원 수
    private String createdAt;   // 생성일

    public String getDeptId()                   { return deptId; }
    public void   setDeptId(String deptId)      { this.deptId = deptId; }
    public String getDeptName()                 { return deptName; }
    public void   setDeptName(String deptName)  { this.deptName = deptName; }
    public String getManagerId()                { return managerId; }
    public void   setManagerId(String managerId){ this.managerId = managerId; }
    public String getManagerName()              { return managerName; }
    public void   setManagerName(String n)      { this.managerName = n; }
    public int    getEmpCount()                 { return empCount; }
    public void   setEmpCount(int empCount)     { this.empCount = empCount; }
    public String getCreatedAt()                { return createdAt; }
    public void   setCreatedAt(String createdAt){ this.createdAt = createdAt; }
}
