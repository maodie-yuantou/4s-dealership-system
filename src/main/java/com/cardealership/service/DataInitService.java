package com.cardealership.service;

import com.cardealership.modules.system.entity.*;
import com.cardealership.modules.system.mapper.*;
import com.cardealership.modules.crm.entity.*;
import com.cardealership.modules.crm.mapper.*;
import com.cardealership.modules.sale.entity.*;
import com.cardealership.modules.sale.mapper.*;
import com.cardealership.modules.stock.entity.*;
import com.cardealership.modules.stock.mapper.*;
import com.cardealership.modules.service.entity.*;
import com.cardealership.modules.service.mapper.*;
import com.cardealership.modules.finance.entity.*;
import com.cardealership.modules.finance.mapper.*;
import com.cardealership.modules.marketing.entity.*;
import com.cardealership.modules.marketing.mapper.*;
import com.cardealership.modules.client.entity.*;
import com.cardealership.modules.client.mapper.*;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Component
@Order(1)
@RequiredArgsConstructor
public class DataInitService implements CommandLineRunner {

    private final SysUserMapper userMapper;
    private final SysRoleMapper roleMapper;
    private final SysPermissionMapper permMapper;
    private final SysDeptMapper deptMapper;
    private final SysDictTypeMapper dictTypeMapper;
    private final SysDictMapper dictMapper;
    private final SysUserRoleMapper userRoleMapper;
    private final SysRolePermissionMapper rolePermMapper;
    private final KbFaqMapper faqMapper;
    private final PasswordEncoder passwordEncoder;
    private final SqlSessionFactory sqlSessionFactory;

    private final CrmCustomerMapper customerMapper;
    private final CrmLeadMapper leadMapper;
    private final CrmFollowUpMapper followUpMapper;
    private final CrmReminderMapper reminderMapper;
    private final SaleOpportunityMapper opportunityMapper;
    private final SaleOrderMapper orderMapper;
    private final StockVehicleMapper stockVehicleMapper;
    private final VehicleVideoMapper videoMapper;
    private final StockAccessoryMapper accessoryMapper;
    private final SvcAppointmentMapper apptMapper;
    private final SvcWorkOrderMapper woMapper;
    private final FinPaymentMapper paymentMapper;
    private final MktCampaignMapper campaignMapper;
    private final MktCouponMapper couponMapper;
    private final MallProductMapper productMapper;

    @Override
    public void run(String... args) {
        if (userMapper.selectById(1L) != null) {
            System.out.println(">>> DataInit: data already exists, skipping init.");
            return;
        }
        System.out.println(">>> DataInit: first startup, initializing seed data...");

        deleteAllData();
        initDepts();
        initRoles();
        initAdmin();
        initPermissions();
        initDicts();
        initFaqs();
        initVehicles();
        initVideos();
        initCustomers();
        initLeads();
        initOrders();
        initAppointments();
        initPayments();
        initMarketing();
        initMall();

        System.out.println(">>> DataInit: all data initialized!");
    }

    private void deleteAllData() {
        String[] tables = {
            "sys_user_role", "sys_role_permission", "sys_user", "sys_role", "sys_permission",
            "sys_dept", "sys_dict", "sys_dict_type", "kb_faq",
            "stock_vehicle", "vehicle_video", "stock_accessory",
            "sale_order", "sale_opportunity",
            "svc_appointment", "svc_work_order",
            "fin_payment",
            "crm_customer", "crm_lead", "crm_follow_up", "crm_reminder",
            "mkt_campaign", "mkt_coupon", "mall_product"
        };
        for (String table : tables) {
            try (SqlSession session = sqlSessionFactory.openSession()) {
                session.getConnection().createStatement().executeUpdate("DELETE FROM " + table);
                session.commit();
            } catch (Exception e) {
                // table may not exist yet, ignore
            }
        }
    }

    private void initDepts() {
        String[][] depts = {
            {"总经办", "HEAD_OFFICE"},
            {"销售部", "SALES"},
            {"售后部", "AFTERSALES"},
            {"市场部", "MARKETING"},
            {"财务部", "FINANCE"},
            {"行政部", "ADMIN"}
        };
        for (int i = 0; i < depts.length; i++) {
            SysDept dept = new SysDept();
            dept.setId((long) (i + 1));
            dept.setParentId(0L);
            dept.setDeptName(depts[i][0]);
            dept.setDeptCode(depts[i][1]);
            dept.setSortOrder(i + 1);
            deptMapper.insert(dept);
        }
    }

    private void initRoles() {
        String[][] roles = {
            {"系统管理员", "ADMIN", "拥有所有权限"},
            {"销售经理", "SALES_MANAGER", "管理销售团队和线索分配"},
            {"销售顾问", "SALES_CONSULTANT", "跟进客户和创建订单"},
            {"售后经理", "SERVICE_MANAGER", "管理售后团队"},
            {"服务顾问", "SERVICE_ADVISOR", "接车和工单管理"},
            {"技师", "TECHNICIAN", "维修执行"},
            {"财务", "FINANCE", "收款、发票和结算"},
            {"店长", "STORE_MANAGER", "查看所有报表和数据"}
        };
        for (int i = 0; i < roles.length; i++) {
            SysRole role = new SysRole();
            role.setId((long) (i + 1));
            role.setRoleName(roles[i][0]);
            role.setRoleCode(roles[i][1]);
            role.setDescription(roles[i][2]);
            roleMapper.insert(role);
        }
    }

    private void initAdmin() {
        // 管理员
        SysUser admin = new SysUser();
        admin.setId(1L);
        admin.setUsername("admin");
        admin.setPassword(passwordEncoder.encode("admin123"));
        admin.setRealName("系统管理员");
        admin.setPhone("13800000000");
        admin.setDeptId(1L);
        userMapper.insert(admin);

        SysUserRole adminRole = new SysUserRole();
        adminRole.setUserId(1L);
        adminRole.setRoleId(1L);
        userRoleMapper.insert(adminRole);

        // 其他用户: {用户名, 姓名, 部门ID, 角色ID}
        Object[][] users = {
            {"zhangsan", "张经理", 2L, 2L},
            {"lisi", "李顾问", 2L, 3L},
            {"wangwu", "王顾问", 2L, 3L},
            {"zhaoliu", "赵经理", 3L, 4L},
            {"sunqi", "孙顾问", 3L, 5L},
            {"zhouba", "周师傅", 3L, 6L},
            {"wujiu", "吴财务", 5L, 7L},
            {"zhengshi", "郑店长", 1L, 8L}
        };
        for (int i = 0; i < users.length; i++) {
            SysUser user = new SysUser();
            user.setId((long) (i + 2));
            user.setUsername((String) users[i][0]);
            user.setPassword(passwordEncoder.encode("123456"));
            user.setRealName((String) users[i][1]);
            user.setDeptId((Long) users[i][2]);
            user.setPhone("1380000000" + (i + 1));
            userMapper.insert(user);

            SysUserRole userRole = new SysUserRole();
            userRole.setUserId(user.getId());
            userRole.setRoleId((Long) users[i][3]);
            userRoleMapper.insert(userRole);
        }
    }

    private void initPermissions() {
        // {id, parentId, name, type, path, icon, sortOrder}
        Object[][] perms = {
            {1L, 0L, "系统管理", "MENU", "/system", "Setting", 1},
            {2L, 1L, "用户管理", "MENU", "/system/users", "User", 10},
            {3L, 1L, "角色管理", "MENU", "/system/roles", "Avatar", 20},
            {4L, 1L, "权限管理", "MENU", "/system/permissions", "Lock", 30},
            {5L, 1L, "部门管理", "MENU", "/system/depts", "OfficeBuilding", 40},
            {6L, 1L, "数据字典", "MENU", "/system/dict", "Collection", 50},
            {7L, 1L, "系统参数", "MENU", "/system/config", "Tools", 60},
            {8L, 1L, "操作日志", "MENU", "/system/logs", "Document", 70},

            {10L, 0L, "客户关系", "MENU", "/crm", "UserFilled", 2},
            {11L, 10L, "客户档案", "MENU", "/crm/customers", "UserFilled", 10},
            {12L, 10L, "跟进记录", "MENU", "/crm/follow-ups", "ChatLineSquare", 20},
            {13L, 10L, "线索公海", "MENU", "/crm/leads", "Ship", 30},
            {14L, 10L, "战败客户", "MENU", "/crm/lost", "Warning", 40},
            {15L, 10L, "提醒任务", "MENU", "/crm/reminders", "AlarmClock", 50},

            {20L, 0L, "整车销售", "MENU", "/sale", "Sell", 3},
            {21L, 20L, "销售机会", "MENU", "/sale/opportunities", "Opportunity", 10},
            {22L, 20L, "订单管理", "MENU", "/sale/orders", "Tickets", 20},
            {23L, 20L, "车辆交付", "MENU", "/sale/deliveries", "Van", 30},
            {24L, 20L, "合同管理", "MENU", "/sale/contracts", "DocumentChecked", 40},

            {30L, 0L, "库存管理", "MENU", "/stock", "Box", 4},
            {31L, 30L, "整车库存", "MENU", "/stock/vehicles", "Van", 10},
            {32L, 30L, "入库管理", "MENU", "/stock/inbound", "Download", 20},
            {33L, 30L, "出库管理", "MENU", "/stock/outbound", "Upload", 30},
            {34L, 30L, "配件库存", "MENU", "/stock/accessories", "Goods", 40},
            {35L, 30L, "盘点管理", "MENU", "/stock/checks", "Check", 50},

            {40L, 0L, "售后维修", "MENU", "/service", "Tool", 5},
            {41L, 40L, "预约管理", "MENU", "/service/appointments", "Calendar", 10},
            {42L, 40L, "维修工单", "MENU", "/service/work-orders", "Notebook", 20},
            {43L, 40L, "结算管理", "MENU", "/service/settlements", "Money", 30},
            {44L, 40L, "回访管理", "MENU", "/service/follow-ups", "Phone", 40},

            {50L, 0L, "财务结算", "MENU", "/finance", "Money", 6},
            {51L, 50L, "收款管理", "MENU", "/finance/payments", "CreditCard", 10},
            {52L, 50L, "发票管理", "MENU", "/finance/invoices", "Receipt", 20},
            {53L, 50L, "退款管理", "MENU", "/finance/refunds", "Money", 30},
            {54L, 50L, "应收账款", "MENU", "/finance/receivables", "Wallet", 40},
            {55L, 50L, "日结管理", "MENU", "/finance/daily-settle", "DataAnalysis", 50},

            {60L, 0L, "统计报表", "MENU", "/report", "DataAnalysis", 7},
            {61L, 60L, "销售漏斗", "MENU", "/report/sales-funnel", "PieChart", 10},
            {62L, 60L, "销售业绩", "MENU", "/report/sales-performance", "TrendCharts", 20},
            {63L, 60L, "售后业绩", "MENU", "/report/service-performance", "TrendCharts", 30},
            {64L, 60L, "库存分析", "MENU", "/report/inventory", "Odometer", 40},
            {65L, 60L, "财务报表", "MENU", "/report/finance", "TrendCharts", 50},

            {70L, 0L, "市场营销", "MENU", "/marketing", "Promotion", 8},
            {71L, 70L, "活动管理", "MENU", "/marketing/campaigns", "Flag", 10},
            {72L, 70L, "渠道管理", "MENU", "/marketing/channels", "Share", 20},
            {73L, 70L, "卡券管理", "MENU", "/marketing/coupons", "Ticket", 30}
        };
        for (Object[] row : perms) {
            SysPermission perm = new SysPermission();
            perm.setId((Long) row[0]);
            perm.setParentId((Long) row[1]);
            perm.setPermName((String) row[2]);
            perm.setPermType((String) row[3]);
            perm.setPath((String) row[4]);
            perm.setIcon((String) row[5]);
            perm.setSortOrder((int) row[6]);
            permMapper.insert(perm);
        }
    }

    private void initDicts() {
        String[][] types = {
            {"客户来源", "customer_source"},
            {"客户级别", "customer_grade"},
            {"付款方式", "payment_method"},
            {"车辆类型", "vehicle_type"},
            {"订单状态", "order_status"},
            {"线索状态", "lead_status"},
            {"跟进方式", "follow_method"}
        };
        for (int i = 0; i < types.length; i++) {
            SysDictType dictType = new SysDictType();
            dictType.setId((long) (i + 1));
            dictType.setDictName(types[i][0]);
            dictType.setDictCode(types[i][1]);
            dictTypeMapper.insert(dictType);
        }

        // {dictTypeId, label, value}
        Object[][] values = {
            {1L, "进店", "WALK_IN"}, {1L, "网销", "ONLINE"}, {1L, "外拓", "OUTREACH"},
            {1L, "老客户介绍", "REFERRAL"}, {1L, "车展", "AUTO_SHOW"}, {1L, "电话", "PHONE"},

            {2L, "H级-1周内成交", "H"}, {2L, "A级-1月内成交", "A"},
            {2L, "B级-3月内成交", "B"}, {2L, "C级-半年内成交", "C"}, {2L, "D级-无意向", "D"},

            {3L, "全款", "FULL"}, {3L, "分期/贷款", "LOAN"},

            {4L, "轿车", "SEDAN"}, {4L, "SUV", "SUV"}, {4L, "MPV", "MPV"},
            {4L, "新能源", "EV"}, {4L, "跑车", "SPORTS"},

            {7L, "电话", "PHONE"}, {7L, "微信", "WECHAT"}, {7L, "到店", "VISIT"}, {7L, "其他", "OTHER"}
        };
        for (int i = 0; i < values.length; i++) {
            SysDict dict = new SysDict();
            dict.setDictTypeId((Long) values[i][0]);
            dict.setDictLabel((String) values[i][1]);
            dict.setDictValue((String) values[i][2]);
            dict.setSortOrder((i % 6) + 1);
            dictMapper.insert(dict);
        }
    }

    private void initFaqs() {
        // {category, question, answer, keywords}
        String[][] faqs = {
            {"MAINTENANCE", "首保什么时候做", "新车首保一般为购车后3个月或3000-5000公里", "首保,保养,时间"},
            {"MAINTENANCE", "小保养和大保养有什么区别", "小保养一般指更换机油和机油滤芯，费用约500-1500元", "保养,大小保养,机油"},
            {"MAINTENANCE", "机油怎么选", "选择机油需看粘度等级和品质等级。全合成油10000公里更换", "机油,全合成,粘度"},
            {"MAINTENANCE", "刹车片多久换一次", "前刹车片一般3-5万公里更换，后刹车片5-8万公里", "刹车片,更换"},
            {"INSURANCE", "新车保险怎么买", "新车需购买交强险+车损险+三者险+不计免赔", "保险,新车,交强险"},
            {"INSURANCE", "出险后怎么处理", "开启双闪、放警示牌、拍照取证、拨打保险公司报案", "出险,事故,报案"},
            {"PRICE", "买车落地价包含哪些费用", "落地价=裸车价+购置税+保险费+上牌费", "落地价,购置税,保险"},
            {"PRICE", "贷款买车和全款哪个划算", "全款总支出更低；贷款资金压力小，有厂家免息政策", "贷款,全款,利息"},
            {"PROCESS", "提车流程是怎样的", "验车→交尾款→买保险→临牌→交车仪式→领资料", "提车,流程,验车"},
            {"PROCESS", "预约保养怎么操作", "通过小程序选择类型、日期和时间段，自动排班", "预约,保养,小程序"},
            {"OTHER", "你们店的营业时间", "销售展厅每日9:00-18:00；售后周一至周六8:30-17:30", "营业时间,展厅"},
            {"OTHER", "有没有代步车服务", "重大维修超48小时可申请免费代步车", "代步车,免费"},
            {"OTHER", "你们店在什么位置", "润达4S店位于XX市XX区XX路XX号汽车城内", "地址,位置,导航"}
        };
        for (String[] row : faqs) {
            KbFaq faq = new KbFaq();
            faq.setCategory(row[0]);
            faq.setQuestion(row[1]);
            faq.setAnswer(row[2]);
            faq.setKeywords(row[3]);
            faqMapper.insert(faq);
        }
    }

    private void initVehicles() {
        // {VIN, brand, model, year, color, type, guidePrice(万)}
        Object[][] vehicles = {
            {"LSVAA4180E2000001", "奥迪", "A6L", "2024", "黑色", "SEDAN", "42.79"},
            {"LBV31FH08R2000002", "宝马", "325Li", "2024", "白色", "SEDAN", "34.99"},
            {"LE4ZG8DB6R2000003", "奔驰", "C260L", "2024", "银色", "SEDAN", "35.18"},
            {"LRW3E7FS8R2000004", "特斯拉", "Model Y", "2024", "蓝色", "SUV", "26.39"},
            {"LC0CE4CB6R2000005", "比亚迪", "汉EV", "2024", "红色", "SEDAN", "21.98"},
            {"LVGBE40KXR2000006", "丰田", "凯美瑞", "2024", "白色", "SEDAN", "19.98"},
            {"LVHRU585XR2000007", "本田", "CR-V", "2024", "黑色", "SUV", "20.89"},
            {"LSVUD60T8R2000008", "大众", "途观L", "2024", "灰色", "SUV", "22.98"},
            {"LS6A3E0E9R2000009", "长安", "深蓝SL03", "2024", "青色", "SEDAN", "16.99"},
            {"HLX33B12XR2000010", "理想", "L8", "2024", "金色", "SUV", "35.98"},
            {"LYVUE10DXR2000011", "沃尔沃", "XC60", "2024", "白色", "SUV", "39.69"},
            {"LSGUD84CXR2000012", "别克", "GL8", "2024", "棕色", "MPV", "32.99"}
        };
        String[] statuses = {
            "IN_STOCK", "IN_STOCK", "SHOWROOM", "IN_STOCK", "IN_STOCK", "RESERVED",
            "IN_STOCK", "SHOWROOM", "IN_STOCK", "IN_STOCK", "IN_TRANSIT", "IN_STOCK"
        };
        for (int i = 0; i < vehicles.length; i++) {
            StockVehicle vehicle = new StockVehicle();
            vehicle.setVin((String) vehicles[i][0]);
            vehicle.setBrand((String) vehicles[i][1]);
            vehicle.setModel((String) vehicles[i][2]);
            vehicle.setModelYear(Integer.parseInt((String) vehicles[i][3]));
            vehicle.setColor((String) vehicles[i][4]);
            vehicle.setVehicleType((String) vehicles[i][5]);
            BigDecimal priceInWan = new BigDecimal((String) vehicles[i][6]);
            vehicle.setGuidePrice(priceInWan.multiply(new BigDecimal("10000")));
            vehicle.setStatus(statuses[i]);
            vehicle.setInboundDate(LocalDate.now().minusDays((i + 1) * 5L));
            stockVehicleMapper.insert(vehicle);
        }
    }

    private void initVideos() {
        // {vehicleId(1-based index in vehicles array), title, videoUrl, sourceType}
        Object[][] videos = {
            {1L, "奥迪A6L 外观详解", "https://www.w3schools.com/html/mov_bbb.mp4", "LINK"},
            {1L, "奥迪A6L 内饰与科技配置", "https://www.w3schools.com/html/movie.mp4", "LINK"},
            {2L, "宝马325Li 运动套件展示", "https://www.w3schools.com/html/mov_bbb.mp4", "LINK"},
            {3L, "奔驰C260L 豪华体验", "https://www.w3schools.com/html/movie.mp4", "LINK"},
            {4L, "特斯拉Model Y 智能驾驶", "https://www.w3schools.com/html/mov_bbb.mp4", "LINK"},
        };
        for (int i = 0; i < videos.length; i++) {
            VehicleVideo video = new VehicleVideo();
            video.setVehicleId((Long) videos[i][0]);
            video.setTitle((String) videos[i][1]);
            video.setVideoUrl((String) videos[i][2]);
            video.setSourceType((String) videos[i][3]);
            video.setSortOrder(i + 1);
            videoMapper.insert(video);
        }
    }

    private void initCustomers() {
        // {name, phone, grade, type, intentModel}
        Object[][] customers = {
            {"张伟", "13900000001", "H", "OWNER", "奥迪A6L"},
            {"李娜", "13900000002", "A", "OWNER", "宝马325Li"},
            {"王磊", "13900000003", "A", "PROSPECT", "奔驰C260L"},
            {"赵敏", "13900000004", "B", "PROSPECT", "特斯拉Model Y"},
            {"陈强", "13900000005", "B", "PROSPECT", "比亚迪汉EV"},
            {"刘洋", "13900000006", "C", "PROSPECT", "丰田凯美瑞"},
            {"周静", "13900000007", "C", "PROSPECT", "本田CR-V"},
            {"吴昊", "13900000008", "H", "PROSPECT", "理想L8"}
        };
        Long[] assigneeIds = {3L, 4L, 3L, 4L, 3L, 4L, 3L, 4L};
        for (int i = 0; i < customers.length; i++) {
            CrmCustomer customer = new CrmCustomer();
            customer.setName((String) customers[i][0]);
            customer.setPhone((String) customers[i][1]);
            customer.setGrade((String) customers[i][2]);
            customer.setCustomerType((String) customers[i][3]);
            customer.setIntentModel((String) customers[i][4]);
            customer.setAssigneeId(assigneeIds[i]);
            customer.setSource("WALK_IN");
            customerMapper.insert(customer);
        }
    }

    private void initLeads() {
        // {name, phone, channel, intentModel, status}
        String[][] leads = {
            {"抖音线索A", "13700000001", "抖音", "宝马X3", "PUBLIC"},
            {"懂车帝线索B", "13700000002", "懂车帝", "奥迪Q5L", "PUBLIC"},
            {"汽车之家C", "13700000003", "汽车之家", "奔驰GLC", "PUBLIC"},
            {"百度线索D", "13700000004", "百度", "特斯拉Model3", "ASSIGNED"},
            {"Walk-in E", "13700000005", "进店", "比亚迪宋PLUS", "ASSIGNED"}
        };
        Long[] assigneeIds = {null, null, null, 3L, 4L};
        for (int i = 0; i < leads.length; i++) {
            CrmLead lead = new CrmLead();
            lead.setCustomerName(leads[i][0]);
            lead.setPhone(leads[i][1]);
            lead.setSourceChannel(leads[i][2]);
            lead.setIntentModel(leads[i][3]);
            lead.setStatus(leads[i][4]);
            lead.setAssigneeId(assigneeIds[i]);
            leadMapper.insert(lead);
        }
    }

    private void initOrders() {
        // {orderNo, customerId, guidePrice(万), discount(万)}
        String[][] orders = {
            {"SO20260501001", "1", "45.00", "3.00"},
            {"SO20260501002", "2", "36.00", "2.50"},
            {"SO20260501003", "3", "38.00", "4.00"}
        };
        String[] statuses = {"COMPLETED", "PENDING_DELIVERY", "PENDING_DEPOSIT"};
        BigDecimal taxRate = new BigDecimal("0.088");
        BigDecimal miscFee = new BigDecimal("7000");

        for (int i = 0; i < orders.length; i++) {
            SaleOrder order = new SaleOrder();
            order.setOrderNo(orders[i][0]);
            order.setCustomerId(Long.parseLong(orders[i][1]));
            BigDecimal guidePrice = new BigDecimal(orders[i][2]).multiply(new BigDecimal("10000"));
            BigDecimal discount = new BigDecimal(orders[i][3]).multiply(new BigDecimal("10000"));
            order.setGuidePrice(guidePrice);
            order.setDiscount(discount);
            order.setTotalPrice(guidePrice.subtract(discount)
                .add(guidePrice.multiply(taxRate))
                .add(miscFee));
            order.setStatus(statuses[i]);
            order.setAssigneeId(3L);
            orderMapper.insert(order);
        }
    }

    private void initAppointments() {
        for (int i = 1; i <= 4; i++) {
            SvcAppointment appointment = new SvcAppointment();
            appointment.setCustomerId((long) i);
            appointment.setCustomerName("客户" + i);
            appointment.setPhone("1390000000" + i);
            appointment.setVehicleInfo("车型" + i);
            appointment.setAppointmentTime(LocalDateTime.now().plusDays(i + 1));
            appointment.setServiceType(i % 2 == 0 ? "MAINTENANCE" : "REPAIR");
            appointment.setStatus("CONFIRMED");
            apptMapper.insert(appointment);
        }

        // {woNo, vehicleDesc, complaint, status}
        String[][] workOrders = {
            {"WO20260501001", "奥迪A6L 京A12345", "发动机异响", "IN_PROGRESS"},
            {"WO20260501002", "宝马325Li 京B67890", "刹车偏软", "RECEPTION"},
            {"WO20260501003", "奔驰C260L 京C11111", "空调不制冷", "COMPLETED"}
        };
        for (String[] row : workOrders) {
            SvcWorkOrder wo = new SvcWorkOrder();
            wo.setWoNo(row[0]);
            wo.setCustomerId(1L);
            wo.setVehicleDesc(row[1]);
            wo.setCustomerComplaint(row[2]);
            wo.setStatus(row[3]);
            wo.setMileage((int) (Math.random() * 50000));
            woMapper.insert(wo);
        }
    }

    private void initPayments() {
        // {type, method, amount, payerName}
        Object[][] payments = {
            {"SALE_DEPOSIT", "CASH", "5000", "张伟"},
            {"SALE_BALANCE", "BANK_CARD", "420000", "李娜"},
            {"SERVICE", "WECHAT", "2800", "王磊"}
        };
        for (int i = 0; i < payments.length; i++) {
            FinPayment payment = new FinPayment();
            payment.setPaymentNo("PAY" + System.nanoTime() % 100000);
            payment.setPaymentType((String) payments[i][0]);
            payment.setPaymentMethod((String) payments[i][1]);
            payment.setAmount(new BigDecimal((String) payments[i][2]));
            payment.setPayerName((String) payments[i][3]);
            payment.setPaidAt(LocalDateTime.now().minusDays(i));
            paymentMapper.insert(payment);
        }
    }

    private void initMarketing() {
        String[][] campaigns = {
            {"五一车展", "AUTO_SHOW", "IN_PROGRESS"},
            {"618团购会", "GROUP_BUY", "IN_PROGRESS"},
            {"周末试驾日", "STORE_EVENT", "PLANNING"}
        };
        for (String[] row : campaigns) {
            MktCampaign campaign = new MktCampaign();
            campaign.setCampaignName(row[0]);
            campaign.setCampaignType(row[1]);
            campaign.setStatus(row[2]);
            campaign.setBudget(new BigDecimal("50000"));
            campaignMapper.insert(campaign);
        }

        String[][] coupons = {
            {"保养现金券", "MAINTENANCE", "200"},
            {"工时抵扣券", "LABOR", "100"},
            {"新车礼包券", "DISCOUNT", "500"}
        };
        for (String[] row : coupons) {
            MktCoupon coupon = new MktCoupon();
            coupon.setCouponName(row[0]);
            coupon.setCouponType(row[1]);
            coupon.setFaceValue(new BigDecimal(row[2]));
            coupon.setTotalQuantity(20);
            coupon.setIssuedQuantity(5);
            coupon.setStatus("ACTIVE");
            coupon.setValidFrom(LocalDate.now());
            coupon.setValidTo(LocalDate.now().plusMonths(3));
            couponMapper.insert(coupon);
        }
    }

    private void initMall() {
        String[][] products = {
            {"全合成保养套餐", "MAINTENANCE_PACKAGE", "498"},
            {"高清行车记录仪", "ACCESSORY", "499"},
            {"3D全包围脚垫", "ACCESSORY", "680"},
            {"车载空气净化器", "ACCESSORY", "299"}
        };
        for (String[] row : products) {
            MallProduct product = new MallProduct();
            product.setProductName(row[0]);
            product.setCategory(row[1]);
            product.setSalePrice(new BigDecimal(row[2]));
            product.setStock(50);
            product.setStatus("ON_SALE");
            productMapper.insert(product);
        }
    }
}
