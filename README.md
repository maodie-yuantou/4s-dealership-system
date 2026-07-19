# 润达 4S 店管理系统 — 全栈汽车经销商管理平台

[![Java](https://img.shields.io/badge/Java-17-orange)](https://openjdk.org/) [![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.4.5-brightgreen)](https://spring.io/) [![Vue](https://img.shields.io/badge/Vue-3.5-4fc08d)](https://vuejs.org/) [![License](https://img.shields.io/badge/License-MIT-blue)](LICENSE) [![Tests](https://img.shields.io/badge/Tests-33%20passed-success)]()

一个全栈汽车 4S 店业务管理系统，集成 RAG 智能客服、整车销售、售后维修、CRM 客户管理、库存管理、财务结算、统计报表等功能，覆盖 4S 店完整业务闭环。提供管理后台（PC 端）和客户 H5（移动端）双端界面。适合作为 Java 后端实习/校招项目展示。

## 架构图

```
graph TB
    subgraph 前端
        Admin[Admin SPA\nVue 3 + TypeScript + Element Plus\nVite + Pinia + ECharts]
        Client[Client H5\nVue 3 + TypeScript + Vant 4\n移动端客户门户]
    end

    subgraph 网关
        Nginx[Nginx 反向代理\n静态资源 + API 代理]
    end

    subgraph "Spring Boot 3.4 后端"
        Security[Security Layer\nJWT + RBAC 权限控制]
        System[system 系统管理\n用户/角色/权限/部门/字典/日志]
        CRM[crm 客户关系\n客户档案/跟进/线索公海/战败分析]
        Sale[sale 整车销售\n机会/订单/审批/交付/合同]
        Stock[stock 库存管理\n整车/配件/盘点/视频]
        Service[service 售后维修\n预约/工单/结算/回访]
        Finance[finance 财务结算\n收款/发票/退款/日结]
        Report[report 统计报表\nKPI/销售漏斗/业绩]
        Marketing[marketing 市场营销\n活动/渠道/卡券]
        ClientMod[client 客户端\nAI 对话/商城/救援/事故/估价]
    end

    subgraph 中间件
        MySQL[(MySQL 8.0\n业务数据 45+ 表)]
        PG[(PostgreSQL 16\npgvector 向量库)]
        Redis[Redis 7\n缓存/限流/Token]
        RabbitMQ[RabbitMQ\n异步消息]
        MinIO[MinIO\n对象存储]
    end

    subgraph AI 服务
        DeepSeek[DeepSeek API\nLLM 大模型]
        ONNX[ONNX Runtime\nall-MiniLM-L6-v2\n本地 Embedding]
    end

    Nginx --> Admin
    Nginx --> Client
    Nginx --> Security
    Security --> System
    Security --> CRM
    Security --> Sale
    Security --> Stock
    Security --> Service
    Security --> Finance
    Security --> Report
    Security --> Marketing
    ClientMod --> DeepSeek
    ClientMod --> ONNX
    ClientMod --> PG
    ClientMod --> RabbitMQ
    System --> MySQL
    CRM --> MySQL
    Sale --> MySQL
    Stock --> MySQL
    Service --> MySQL
    Finance --> MySQL
    Marketing --> MySQL
    ClientMod --> MySQL
    Sale --> MinIO
    Stock --> MinIO
    Service --> Redis
    ClientMod --> Redis
```

## 技术栈

| 层级 | 技术 | 说明 |
|------|------|------|
| 前端管理后台 | Vue 3 + TypeScript + Vite + Pinia + Element Plus + ECharts | SPA 单页应用, 图表可视化 |
| 前端客户端 | Vue 3 + TypeScript + Vite + Pinia + Vant 4 | 移动端 H5, 客户自助服务 |
| 后端 | Spring Boot 3.4.5 + MyBatis-Plus 3.5.7 | 单模块按包分层, 9 大业务模块 |
| 安全 | Spring Security 6 + JWT (JJWT 0.12.5) | 双 Token：Access 30min / Refresh 7d |
| RBAC | 8 种角色, 73 个权限节点 | @PreAuthorize 方法级权限控制 |
| AI | LangChain4j 1.0.0-beta1 + DeepSeek Chat | OpenAI 兼容适配, SSE 流式输出 |
| 嵌入 | all-MiniLM-L6-v2 (384维) | ONNX Runtime 本地运行 |
| 向量库 | PostgreSQL 16 + pgvector | 余弦相似度检索 FAQ |
| 业务库 | MySQL 8.0 | InnoDB, 45+ 张表 |
| 缓存 | Redis 7 + Spring Data Redis | Token 存储, 验证码, 缓存 |
| 限流 | Redisson 3.32.0 RRateLimiter | AOP 注解式限流 |
| 消息队列 | RabbitMQ 3.13 | 聊天历史异步持久化 + 通知异步分发 |
| 实时通信 | WebSocket (STOMP) | 通知推送, SockJS 降级 |
| 对象存储 | MinIO | 商品图片/视频/头像上传 |
| API 文档 | Knife4j (SpringDoc OpenAPI) | /doc.html 在线调试, 中文界面 |
| 测试 | JUnit 5 + Mockito + AssertJ + MockMvc | 33 个测试全部通过 |
| 部署 | Docker Compose + Nginx | 一键启动 6 个中间件 |
| CI/CD | GitHub Actions | 自动编译/测试 |

## 模块结构（9 大业务模块）

```
cardealership/
├── common/                # 公共：Result<T>, @RateLimit 限流注解, TraceIdFilter,
│   │                      #   GlobalExceptionHandler, RabbitMQ 生产者/消费者
│   ├── config/            # 配置：Security, JWT, Redis, MinIO, RabbitMQ, WebSocket,
│   │                      #   MyBatis-Plus, Knife4j, DeepSeek, pgvector
│   ├── security/          # 安全：JwtTokenProvider, JwtAuthFilter, UserDetailsImpl
│   └── service/           # 公共服务：MinioService, NotificationService,
│                          #   VectorSearchService, EmbeddingService, DataInitService
├── modules/
│   ├── system/            # 系统管理：用户/角色/权限(RBAC)、部门、字典、配置、操作日志
│   ├── crm/               # 客户关系：客户档案、跟进记录、线索公海(分配/回收/转化)、
│   │                      #   战败分析、提醒任务(生日/保险/年检/回访)
│   ├── sale/              # 整车销售：销售机会、订单(多级审批)、交付(PDI/洗车/交车仪式)、
│   │                      #   合同、衍生业务(保险/金融/置换/延保)
│   ├── stock/             # 库存管理：整车入库/出库、VIN 级追踪、配件管理、
│   │                      #   低库存预警、盘点(差异分析)、车辆视频
│   ├── service/           # 售后维修：预约管理、维修工单(接车/派工/维修/质检/洗车/结算)、
│   │                      #   配件领料、结算、回访
│   ├── finance/           # 财务结算：收款(多支付方式)、发票(开具/作废/冲红)、
│   │                      #   退款、应收账款(账龄)、日结、利润核算
│   ├── report/            # 统计报表：KPI 仪表盘、销售漏斗、销售业绩
│   ├── marketing/         # 市场营销：活动管理、线索渠道(抖音/懂车帝/汽车之家)、卡券
│   └── client/            # 客户门户：手机号登录、我的车辆、预约、透明车间、
│                          #   精品商城、道路救援、事故报案、二手车估价、AI 智能客服
└── Application.java       # 启动类
```

## 核心功能与面试亮点

| 功能 | 技术实现 | 面试价值 |
|------|----------|----------|
| RAG AI 客服 | FAQ 关键词匹配 + pgvector 语义检索 → DeepSeek LLM 生成回答 | 展示 AI 工程能力 |
| SSE 流式输出 | SseEmitter 流式推送 AI 回复, 支持中断 | 理解 HTTP 流式协议 |
| 混合检索 | pgvector 余弦相似度 + MySQL LIKE 关键词兜底 | 向量数据库实战 |
| 线索公海 | 线索池自动分配/手动领取/超时回收机制 | 复杂业务建模 |
| 订单审批流 | 多级审批 + 状态机流转, 数据库行锁防并发 | 工作流设计 |
| 通知系统 | RabbitMQ 异步 + WebSocket 实时推送 + 离线拉取兜底 | 消息队列实战 |
| RBAC 权限 | 8 种角色、73 权限节点, @PreAuthorize 方法级控制 | 权限体系设计 |
| JWT 双 Token | Access 30min + Refresh 7d, Redis 存储 Refresh Token | 认证鉴权方案 |
| 限流保护 | Redisson RRateLimiter + AOP @RateLimit 注解 | 高并发防护 |
| 请求追踪 | TraceIdFilter 注入全局 traceId, 异常响应带回 | 可观测性 |
| 结构化日志 | Logback MDC traceId, JSON 文件输出 | 排障效率 |
| 透明车间 | WebSocket 实时推送维修进度, 客户 H5 端查看 | 实时通信方案 |
| 库存预警 | Redis 缓存库存数量, 低于阈值自动告警 | 缓存策略设计 |
| Docker 部署 | 6 个中间件 Docker Compose 一键编排 + Nginx 反向代理 | 容器化能力 |
| 测试体系 | JUnit 5 + Mockito + AssertJ + MockMvc, 33 tests, H2 隔离 | 代码质量意识 |
| CI/CD | GitHub Actions 自动编译/测试 | DevOps 能力 |

## 快速开始

### 环境要求

- JDK 17+
- Maven 3.8+
- Docker Desktop
- Node.js 18+

### 1. 一键启动中间件

```bash
# 启动所有中间件 (MySQL, Redis, RabbitMQ, MinIO, PostgreSQL, Nginx)
docker-compose up -d

# 确保 MySQL 容器在运行
docker start mysql-project
```

### 2. 设置 API Key

```bash
# Windows PowerShell
$env:DEEPSEEK_API_KEY = "sk-your-key"

# macOS / Linux
export DEEPSEEK_API_KEY=sk-your-key
```

### 3. 启动后端

```bash
mvn spring-boot:run
# 或 IDEA 中运行 Application.java
```

### 4. 启动前端

```bash
# 管理后台 (http://localhost:5173)
cd frontend && npm install && npm run dev

# 客户端 H5 (http://localhost:5174)
cd frontend-client && npm install && npm run dev
```

### 5. 运行测试

```bash
# 全部测试
mvn test

# 指定测试类
mvn test -Dtest="AuthServiceTest,StockServiceTest"
```

### 访问地址

| 服务 | 地址 | 凭证 |
|------|------|------|
| 管理后台 | http://localhost:5173 | — |
| 客户端 H5 | http://localhost:5174 | — |
| API 文档 | http://localhost:8080/doc.html | — |
| RabbitMQ 控制台 | http://localhost:15672 | guest/guest |
| MinIO 控制台 | http://localhost:9001 | minioadmin/minioadmin123 |

### 测试账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 系统管理员 | `admin` | `admin123` |
| 销售经理 | `zhangsan` | `123456` |
| 店长 | `zhengshi` | `123456` |

## 面试问答

### Q: 项目最大的亮点是什么？

**A:** 完整覆盖 4S 店"集客→跟进→试驾→下单→交付→售后→回访"全业务链路，9 大模块 45+ 张表。技术上集成 RAG AI 智能客服（LangChain4j + DeepSeek + pgvector 向量检索 + ONNX 本地 Embedding），展示了对 AI 工程化的理解。同时 RBAC 权限体系（8 角色 73 权限节点）、订单多级审批流、线索公海机制等体现了复杂业务建模能力。

### Q: AI 智能客服是怎么实现的？

**A:** 三层架构：① FAQ 知识库预先通过 ONNX Runtime 本地运行 all-MiniLM-L6-v2 模型生成 384 维向量，存入 PostgreSQL pgvector；② 用户提问时先做关键词精确匹配，未命中则用 pgvector 余弦相似度检索（阈值 0.6），取 top-N 相关 FAQ；③ 检索结果 + 最近 20 条对话历史拼接为 Prompt，通过 LangChain4j 调用 DeepSeek Chat API 生成回答，SSE 流式返回前端。如果 FAQ 无法解决，自动创建客服工单转人工处理。

### Q: 为什么用 LangChain4j 而不是 Python LangChain？

**A:** Java 生态原生集成，无需跨语言调用。Spring Boot 深度整合，国内企业 Java 后端仍是主力。LangChain4j 提供 ChatModel、EmbeddingStore、Retriever 等与 Python 版对等的抽象，且 Spring Boot Starter 开箱即用。

### Q: 线索公海是怎么设计的？

**A:** 销售线索进入公海池后，销售顾问可手动领取或系统按规则自动分配。已领取线索有跟进期限，超时未跟进自动回收至公海。领取/回收记录写入 `crm_lead_assign_log` 表，支持审计追溯。线索转化成功后自动创建客户档案和销售机会，实现 CRM→销售的数据贯通。

### Q: 订单审批流程怎么实现？

**A:** 销售订单提交后进入多级审批：销售经理→财务→店长（根据金额不同走不同层级）。使用状态机模式管理订单状态流转，数据库行锁 + 乐观锁防止并发审批。审批通过后自动触发库存出库、财务应收账款、通知推送等后续流程。

### Q: 怎么处理并发和数据一致性？

**A:** 三层防护：① 库存扣减使用 MySQL 行锁（`SELECT ... FOR UPDATE`）保证原子性；② Redisson 分布式锁保护关键业务（如订单审批、线索分配）；③ @RateLimit 注解基于 Redisson RRateLimiter 做接口限流。AOP 切面 + 注解方式零侵入。

### Q: 消息队列怎么用的？

**A:** 两个场景：① AI 聊天记录通过 RabbitMQ 异步持久化到 MySQL，避免阻塞 SSE 流式响应；② 业务通知（审批结果、预约提醒、库存预警等）通过 RabbitMQ 解耦——业务模块发送消息，通知模块消费后通过 WebSocket 推送给用户。失败不影响主流程，`default-requeue-rejected: false` 避免死循环。

### Q: JWT 双 Token 机制怎么设计的？

**A:** Access Token 30 分钟有效期，直接携带用户角色权限信息，每次请求验证。Refresh Token 7 天有效期，存储在 Redis 中，用于无感刷新 Access Token。前端拦截器在 401 时自动用 Refresh Token 换取新的 Access Token，用户无感知。登出时删除 Redis 中的 Refresh Token 实现主动失效。

### Q: 透明车间功能怎么实现？

**A:** 维修工单从接车到结算共 7 个状态节点，技师在管理后台更新工单状态后，通过 WebSocket 实时推送到该客户对应的 H5 端。客户无需到店即可在手机上查看爱车维修进度。WebSocket 使用 STOMP 协议 + SockJS 降级兼容。

### Q: RBAC 权限模型怎么设计的？

**A:** 用户-角色-权限三级模型。8 种预置角色对应 4S 店真实岗位（销售经理、销售顾问、服务经理、服务顾问、技师、财务、店长、管理员），73 个权限节点覆盖菜单/按钮/接口级别。Spring Security @PreAuthorize 注解在 Controller 层做方法级鉴权，`SysUserDetails` 实现 `UserDetails` 接口加载权限列表。

### Q: 项目测试情况？

**A:** 33 个测试覆盖 6 个模块：认证服务(6)、售后维修(8)、AI 客服(8)、库存服务(7)、库存控制器(3)、应用冒烟(1)。使用 JUnit 5 + Mockito 单元测试、MockMvc 集成测试、AssertJ 流式断言。测试配置使用 H2 内存数据库隔离，排除 Redis/RabbitMQ/Redisson 自动配置。

### Q: 项目还有哪些可以改进的？

**A:** ① 当前单模块按包分层，可拆分为 Maven 多模块（common/system/crm/sale/stock/service/finance/report/marketing/client/app），模块间通过 Feign 或 Dubbo 通信；② 引入 Prometheus + Grafana 监控业务指标（今日线索量、订单转化率、维修产值等）；③ Elasticsearch 替代 MySQL LIKE 实现全文搜索；④ 前端增加骨架屏、离线 PWA、小程序版本；⑤ 引入 Seat 分布式事务保证跨模块数据一致性。

## License

MIT
