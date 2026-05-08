package egovframework.member.vo;

public class MemberVO {
    private String memberId;
    private String password;
    private String name;
    private String email;
    private String role;
    private String status;      // 가입 승인 상태 (PENDING/ACTIVE/REJECTED)
    private String department;  // 부서
    private String empNo;       // 사번
    private String birthDate;   // 생년월일
    private String phone;       // 전화번호
    private String position;    // 직급
    private String gender;      // 성별 (M/F)
    private String deptId;       // 부서 코드 (FK)
    private String deptName;     // 부서명 (JOIN용)
    

    // getter / setter
    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    public String getEmpNo() { return empNo; }
    public void setEmpNo(String empNo) { this.empNo = empNo; }
    public String getBirthDate() { return birthDate; }
    public void setBirthDate(String birthDate) { this.birthDate = birthDate; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    private String keyword; // 검색 키워드

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }
    
    public String getDeptId() { return deptId; }
    public void setDeptId(String deptId) { this.deptId = deptId; }
    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }
}