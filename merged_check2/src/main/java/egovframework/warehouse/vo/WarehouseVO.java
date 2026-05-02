// ============================================================
// WarehouseVO.java
// egovframework.warehouse.vo
// ============================================================
package egovframework.warehouse.vo;

public class WarehouseVO {
    private Long    warehouseId;
    private String  warehouseCode;
    private String  warehouseName;
    private String  location;
    private String  type;
    private Integer isActive;
    private String  keyword; // 검색용

    public Long    getWarehouseId()   { return warehouseId; }
    public void    setWarehouseId(Long warehouseId) { this.warehouseId = warehouseId; }
    public String  getWarehouseCode() { return warehouseCode; }
    public void    setWarehouseCode(String warehouseCode) { this.warehouseCode = warehouseCode; }
    public String  getWarehouseName() { return warehouseName; }
    public void    setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
    public String  getLocation()      { return location; }
    public void    setLocation(String location) { this.location = location; }
    public String  getType()          { return type; }
    public void    setType(String type) { this.type = type; }
    public Integer getIsActive()      { return isActive; }
    public void    setIsActive(Integer isActive) { this.isActive = isActive; }
    public String  getKeyword()       { return keyword; }
    public void    setKeyword(String keyword) { this.keyword = keyword; }
}
