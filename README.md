<div align="center">

![](./images/title.png)

**基于RPI和有效上下文理论，让Claude Code一次只专注于一件事**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT) [![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-green.svg)](https://claude.ai/code) [![Share](https://img.shields.io/badge/share-000000?logo=x&logoColor=white)](https://x.com/intent/tweet?text=GudaStudio%20Commands：Claude%20Code%20多模型协作工作流%20https://github.com/TuWeiZhi/commands%20%23AI%20%23Coding%20%23ClaudeCode)

⭐ 在 GitHub 上给我们点星~您的支持对我们意义重大！🙏😊

[English](./docs/README_EN.md) | 简体中文

</div>

---

> 📌 **本项目 fork 自上游 [GuDaStudio/commands](https://github.com/GuDaStudio/commands)，并在此基础上进行二次开发。** 主要改动：将已废弃的 Gemini CLI 包装器（`geminimcp`）替换为 **Antigravity（`agy`）MCP**，并将 Codex / Gemini / Agy 三个 MCP 的安装源统一切换为当前维护者的 fork（`TuWeiZhi/codexmcp`、`TuWeiZhi/geminimcp`[已归档]、`TuWeiZhi/agy-mcp`）。原始工作流（RPI / OpenSpec / 多模型协作）逻辑保持不变。特此致谢上游作者。

## 一、项目简介

**GudaStudio Commands** 收录了 **GudaStudio** 开发的 Claude Code 自定义命令集合。核心命令 `gudaspec` 实现了基于**RPI(Research-Plan-Implementation)编码理论**的完整流程，并融合openspec和多模型协作以让claued code**更适用于复杂场景、长时间编码任务**。同时，本项目引入了 *以人为本* 的操作理念，允许用户通过多阶段手动分割上下文，**让claude code的有效上下文（约80K）被极致利用**！完整功能请查看使用示例！

### gudaspec 命令集

| 命令 | 功能 |
|------|------|
| `/gudaspec:init` | 初始化 OpenSpec 环境，验证 MCP 工具可用性 |
| `/gudaspec:research` | 并行探索代码库，将需求转化为约束集 |
| `/gudaspec:plan` | 多模型分析，生成零决策执行计划与 PBT 属性 |
| `/gudaspec:implementation` | 多模型协作实现，原型重构为生产级代码 |

---

## 二、快速开始

### 0. 前置要求

- [Claude Code](https://docs.claude.com/docs/claude-code) (v2.1.15+)
- [Auggie MCP](https://docs.augmentcode.com/context-services/mcp/quickstart-claude-code)


### 1. 获取仓库

```bash
git clone https://github.com/TuWeiZhi/commands
cd commands
```

### 2. 安装命令

<details>
<summary><b>Linux / macOS</b></summary>

```bash
# 用户级安装（所有项目生效）
./install.sh --user

# 项目级安装（仅当前项目生效）
./install.sh --project

# 自定义路径
./install.sh --target /your/custom/path
```

</details>

<details>
<summary><b>Windows (PowerShell)</b></summary>

```powershell
# 用户级安装（所有项目生效）
.\install.ps1 -User

# 项目级安装（仅当前项目生效）
.\install.ps1 -Project

# 自定义路径
.\install.ps1 -Target C:\your\custom\path
```

</details>

<details>
<summary>参数说明</summary>

| 参数 (Bash) | 参数 (PowerShell) | 简写 | 说明 |
|-------------|-------------------|------|------|
| `--user` | `-User` | `-u` | 安装到用户级目录 (`~/.claude/commands/`) |
| `--project` | `-Project` | `-p` | 安装到项目级目录 (`./.claude/commands/`) |
| `--target <path>` | `-Target <path>` | `-t` | 安装到自定义路径 |
| `--help` | `-Help` | `-h` | 显示帮助信息 |

</details>

### 2.5 安装多模型 MCP 后端（可选但强烈推荐）

`install.sh` 只装了命令本体；gudaspec 的「多模型协作」能力依赖两个外部 MCP 后端。不装的话，`/gudaspec:plan`、`/gudaspec:implementation` 的多模型原型与审查将不可用（`/gudaspec:init` 会告警）。

前置：已安装 [uv](https://docs.astral.sh/uv/) 与对应 CLI（Codex CLI、Antigravity `agy` CLI）。

<details>
<summary><b>Linux / macOS / Windows（CMD）</b></summary>

```bash
# Codex MCP（后端/逻辑）——fork 源
claude mcp add codex -s user --transport stdio -- uvx --from git+https://github.com/TuWeiZhi/codexmcp.git codexmcp

# Agy MCP（前端/UI）——fork 源，替代已废弃的 Gemini MCP
claude mcp add agy -s user --transport stdio -- uvx --from git+https://github.com/TuWeiZhi/agy-mcp.git agymcp

# 验证（期望 codex / agy 均 ✓ Connected）
claude mcp list
```

</details>

<details>
<summary><b>Windows（PowerShell）</b></summary>

> PowerShell 对 `--` 后参数解析有 bug，上方的 `claude mcp add ... -- uvx --from ...` 会报 `error: unknown option '--from'`（[claude-code#3825](https://github.com/anthropics/claude-code/issues/3825)）。**最简解法：改用 CMD（cmd.exe）运行上方同样的命令**；若必须留在 PowerShell，用 `add-json`（单引号包 JSON，内部双引号原样保留）：

```powershell
# Codex MCP
claude mcp add-json codex -s user '{"type":"stdio","command":"uvx","args":["--from","git+https://github.com/TuWeiZhi/codexmcp.git","codexmcp"]}'

# Agy MCP
claude mcp add-json agy -s user '{"type":"stdio","command":"uvx","args":["--from","git+https://github.com/TuWeiZhi/agy-mcp.git","agymcp"]}'

# 验证
claude mcp list
```

</details>

> - OpenSpec CLI 无需手动安装——`/gudaspec:init` 会自动装。
> - 想用 PyPI 官方包替代 agy fork 源：`uv tool install agy-mcp` 后 `claude mcp add agy -s user --transport stdio -- agymcp`（上游 [Boulea7/agy-mcp](https://github.com/Boulea7/agy-mcp)）。
> - 从旧版 Gemini MCP 升级？见下方「四、迁移指南」。

### 3. 验证安装

启动 Claude Code 后输入 `/gudaspec` 即可查看可用命令。

### 4. 配置全局提示词🎊 
在 `~/.claude/CLAUDE.md` 中使用以下提示词。
````markdown
# CLAUDE.md

## 0. Global Protocols

所有操作必须严格遵循以下系统约束：

| 规则 | 要求 |
|------|------|
| **交互语言** | 工具调用与模型内部使用 **English**；面向用户的输出使用 **中文** |
| **思考语言** | MUST ULTRA Thinking in **ENGLISH** |
| **格式要求** | 标准 Markdown，代码块和特定文本结果应使用反引号标注。擅长使用四个或更多 ````markdown 包装器 |
| **多轮对话** | 如果工具返回的有可持续对话字段，比如 `SESSION_ID`，表明工具支持多轮对话，此时记录该字段，并在随后的工具调用中**强制思考**，是否继续进行对话。例如，Codex/Agy 有时会因工具调用中断会话，若没有得到需要的回复，则应继续对话 |
| **沙箱安全** | 严禁 Codex/Agy 对文件系统进行写操作。所有代码获取必须请求 `unified diff patch` 格式 |
| **代码主权** | 外部模型生成的代码仅作为逻辑参考（Prototype），最终交付代码**必须经过重构**，确保无冗余、企业级标准 |
| **风格定义** | 整体代码风格**始终定位**为精简高效、毫无冗余。该要求同样适用于注释与文档，且对于这两者，严格遵循**非必要不形成**的核心原则 |
| **仅对需求做针对性改动** | 严禁影响用户现有的其他功能 |
| **判断依据** | 始终以项目代码、grok 的搜索结果作为判断依据，严禁使用一般知识进行猜测，允许向用户表明自己的不确定性。在调用编程语言的非内置库时，必须启用 grok 搜索，以文档作为判断依据进行编码 |

---

## Core Instruction for CodeX MCP

在任何时刻，你必须思考当前过程可以如何与 codex 进行协作，如何调用 Codex 为你提供的 MCP 工具作为你客观全面分析的保障。

其中你**务必执行**以下几个步骤：

**1** 在你对用户需求形成初步分析后，将用户需求、初始思路告知 codex，并要求其完善需求分析和实施计划。

**2** 在实施具体编码任务前，**必须向 codex 索要代码实现原型（要求 codex 仅给出 unified diff patch，严禁对代码做任何真实修改）**。在获取代码原型后，你**只能以此为逻辑参考，再次对代码修改进行重写**，形成企业生产级别、可读性极高、可维护性极高的代码后，才能实施具体编程修改任务。

**3** 无论何时，只要完成切实编码行为后，**必须立即使用 codex review 代码改动和对应需求完成程度**。

**4** codex 只能给出参考，你**必须有自己的思考，甚至需要对 codex 的回答提出置疑**。尽信书则不如无书，你与 codex 的最终使命都是达成统一、全面、精准的意见，所以你们必须不断争辩已找到通向真理的唯一途径。

---

## Codex Tool Invocation Specification

### 1. 工具概述

codex MCP 提供了一个工具 `codex`，用于执行 AI 辅助的编码任务。该工具**通过 MCP 协议调用**，无需使用命令行。

### 2. 工具参数

**必选**参数：
- PROMPT (string): 发送给 codex 的任务指令
- cd (Path): codex 执行任务的工作目录根路径

可选参数：
- sandbox (string): 沙箱策略，可选值：
  - "read-only" (默认): 只读模式，最安全
  - "workspace-write": 允许在工作区写入
  - "danger-full-access": 完全访问权限
- SESSION_ID (UUID | null): 用于继续之前的会话以与 codex 进行多轮交互，默认为 None（开启新会话）
- skip_git_repo_check (boolean): 是否允许在非 Git 仓库中运行，默认 False
- return_all_messages (boolean): 是否返回所有消息（包括推理、工具调用等），默认 False
- image (List[Path] | null): 附加一个或多个图片文件到初始提示词，默认为 None
- model (string | null): 指定使用的模型，默认为 None（使用用户默认配置）
- yolo (boolean | null): 无需审批运行所有命令（跳过沙箱），默认 False
- profile (string | null): 从 `~/.codex/config.toml` 加载的配置文件名称，默认为 None（使用用户默认配置）

返回值：
```json
{
  "success": true,
  "SESSION_ID": "uuid-string",
  "agent_messages": "agent回复的文本内容",
  "all_messages": []
}
```
或失败时：
```json
{
  "success": false,
  "error": "错误信息"
}
```

### 3. 使用方式

开启新对话：
- 不传 SESSION_ID 参数（或传 None）
- 工具会返回新的 SESSION_ID 用于后续对话

继续之前的对话：
- 将之前返回的 SESSION_ID 作为参数传入
- 同一会话的上下文会被保留

### 4. 调用规范

**必须遵守**：
- 每次调用 codex 工具时，必须保存返回的 SESSION_ID，以便后续继续对话
- cd 参数必须指向存在的目录，否则工具会静默失败
- 严禁 codex 对代码进行实际修改，使用 `sandbox="read-only"` 以避免意外，并要求 codex 仅给出 unified diff patch 即可

推荐用法：
- 如需详细追踪 codex 的推理过程和工具调用，设置 `return_all_messages=True`
- 对于精准定位、debug、代码原型快速编写等任务，优先使用 codex 工具

### 5. 注意事项

- 会话管理：始终追踪 SESSION_ID，避免会话混乱
- 工作目录：确保 cd 参数指向正确且存在的目录
- 错误处理：检查返回值的 success 字段，处理可能的错误

---

## Core Instruction for Agy MCP

在任何时刻，你必须思考当前过程可以如何与 agy 进行协作，如何调用 agy 为你提供的 MCP 工具作为你**客观全面分析**的保障。

其中你**务必执行**以下几个步骤：

**1** 在你对用户需求**形成初步分析后**：
（1）首先将用户**原始需求（一字不差，严禁转述）**、以及你的初始思路告知 agy；
（2）与 agy 进行**充分讨论、辩驳**，以完善需求分析和实施计划。这一步的结束标志为，**必须**确保对用户需求的透彻理解，并**生成切实可行的行动计划**。

**2** 在实施具体编码任务前，你**必须向 agy 索要代码实现原型**（要求 agy 仅给出 unified diff patch，严禁对代码做任何真实修改；agy-mcp 可用 `mode="prototype"` 调用，天然不落盘）。在获取代码原型后，你**只能以此为逻辑参考，再次对代码修改进行重写**，形成企业生产级别、可读性极高、可维护性极高的代码后，才能实施具体编程修改任务。

- **注意：** agy（底层为 Antigravity/Gemini 模型）十分擅长前端代码，并精通样式、UI 组件设计。在涉及前端代码时，你必须向其索要代码原型（CSS/React/Vue/HTML 等前端代码），任何时刻，你**必须以 agy 的前端设计（原型代码）为最终的前端代码基点**。
- 例如，当你识别到用户给出了前端设计需求，你的首要行为必须自动调整为，将用户需求原封不动转发给 agy，并让其出具代码示例（此阶段严禁对用户需求进行任何改动、简写等等）。即你必须从 agy 获取代码基点，才可以进行接下来的各种行为。

---

## Agy Tool Invocation Specification

### 1. 工具概述

agy-mcp 把 Antigravity CLI（`agy`）包装成 MCP 工具供 Claude Code 调用，共 11 个 typed 工具；本工作流主用其一次性同步工具 `agy`（对应 `mcp__agy__agy`）。它（底层为 Antigravity/Gemini 模型）拥有极强的前端审美、任务规划与需求理解能力，以**独立模型、独立上下文**运行。

### 2. 工具参数（主工具 `agy`）

**必选**参数：
- PROMPT (string): 发送给 agy 的任务指令
- cd (Path): agy 执行任务的工作目录根路径

可选参数（常用的）：
- sandbox: 沙箱策略
- SESSION_ID (string | null): 续接之前的会话以进行多轮交互，默认 None（开启新会话）
- mode: 调用模式，取值：
  - `"prototype"`（**推荐用于取原型**）: 仅产出 unified diff patch，不落盘
  - `"review"`: 第二意见 / 代码审查
  - `"execute"`: 实际执行（须显式 `allow_write=True`，默认 worktree 隔离）
  - `"ask"`: 纯问答
- allow_write (bool): 是否允许写入，默认 False
- worktree / backend / output_protocol / extra_env: 高级选项，按需使用

其余工具（`agy_continue` 续会话、`agy_start`/`agy_status`/`agy_result` 长任务、`agy_doctor` 环境自检等）按需调用。

### 3. 使用方式与规范

**必须遵守的限制**：
- **会话管理**：捕获返回的 `SESSION_ID` 用于多轮对话
- **后端避让**：复杂后端业务逻辑优先交由 Codex（Route B），agy 主攻前端/UI（Route A）
- **沙箱**：取原型用 `mode="prototype"`（不 `allow_write`），严禁 agy 直接写文件

**擅长场景（必须优先调用 agy）**：
- **需求清晰化**：在任务开始阶段辅助生成引导性问题
- **任务规划**：生成 Step-by-step 的实施计划
- **前端原型**：编写 CSS、HTML、UI 组件代码，调整样式风格
````

---

## 三、使用示例
本项目的核心观念是**将有效的上下文专注于一件事**，本节将会以 `从零生成一个可视化天气页面` 为例，带您感受本项目的独特魅力！😀
>以下示例均使用**claude opus 4.5**进行，并强烈建议您**开启推理模式以加强claude的指令服从能力**！

### 0. Init 项目初始化
**0.1** 进入项目，打开claude code，键入 `/gudaspec:init`，为该项目进行gudaspec初始化。
![](./images/init0.png)

**0.2** claude会为您自动安装`openspec`，并检测`Codex-MCP` 和 `Agy-MCP`是否可用。
![](./images/init1.png)

**0.3** 本阶段任务已完成，键入`/clear`，清空当前上下文并新开对话。

### 1. Research 需求研究
该阶段旨在根据项目的已有代码/掌握的初步信息，对用户的需求进行初步理解，并形成标准OpenSpec文档。

**1.1** 在新的会话窗口中输入以下内容：
```
/gudaspec:research
我需要生成一个美观的实时天气展示页面。要求：
  1. 实时天气信息必须为真实信息，包含温度、湿度等
  2. 用户可以选择北京、上海、深圳三个城市
  3. 四种不同的基础天气（大风、降雨、晴天、下雪），有不同的页面展示。
  4. UI设计极具美感，参考苹果公司的顶级前端设计。
```
claude会帮您自动调研并生成openspec格式的初步提案。
![](./images/research0.png)
![](./images/research1.png)

**1.2** 当您的需求中含有明显歧义时，claude会主动征求您的意见。
![](./images/research3.png)

**1.3** 最终claude会为您生成初步的spec文档，此时只用了*59.5K*上下文，距离**claude的最专注上下文长度80K**还有不少距离。🥳
![](./images/research4.png)

### 2. Plan 计划制定
本阶段的任务是彻底消除用户需求中的不确定性，并生成可执行计划。同时为计划提供可验证属性。

**2.1** 在新的会话窗口中输入以下内容，claude会自动帮您找到待完成的需求。
```
/gudaspec:plan
```
![](./images/plan0.png)

**2.2** claude会启动多模型（codex/agy）协作，来对初步需求报告中的实现方案进行分析细化。
![](./images/plan1.png)

**2.3** 获取到多模型的分析方案后，claude会进一步细化需求，彻底消除技术上的模糊性。
![](./images/plan2.png)

**2.4** 在所有决策项完成后，claude会提取 Property-Based Testing 属性，供后续阶段验证使用。
![](./images/plan3.png)

**2.5** 直至计划方案变成后续可零决策顺序执行的pipeline，claude会生成完整的spec文档，该阶段任务完成，输入`/clear`，清空当前上下文，新开会话窗口。
![](./images/plan4.png)

### 3. Implementation 代码实现
本阶段的目标是执行具体的代码实现，直至完成用户需求。

**3.1** 在新会话窗口中，执行以下命令，claude会自动帮您识别待完成的需求提案。
```
/gudaspec:implementation
```
![](./images/imp0.png)

**3.2** claude会自动识别最小可验证任务来进行逐步实现，以更好的**帮助您控制上下文！**
![](./images/imp1.png)

**3.3** 在完成一阶段任务后，claude会暂停询问您是否继续的意见，此时我们**强烈建议**您关注上下文窗口，**若小于80k则可以继续下一阶段的实现**；反之，可以输入`/clear`新开会话窗口，从**3.1**继续实现。
![](./images/imp2.png)

**3.4** 过程中，claude会自动启用多模型代码原型获取（前端/UI → Agy | 后端/逻辑 → Codex），并在每完成一阶段任务后启用多模型review来保证代码可靠性。
![](./images/imp3.png)

**3.5** 成果展示。直至所有任务完成，我们就可以获得一个拥有真实数据的天气系统啦！😀(左侧为系统截图，右侧为中央气象台截图)
![](./images/result.png)



---

## 四、迁移指南：Gemini MCP → Agy MCP（仅老用户）

> ⚠️ Google 的 **Gemini CLI 已废弃（EOL）**，继任者为 **Antigravity CLI（`agy`）**。本项目已将"前端/UI 多模型协作"的底层从 Gemini CLI 包装器（`geminimcp`，工具 `mcp__gemini__gemini`）切换为 **Antigravity CLI 包装器 agy-mcp**（fork 自 [Boulea7/agy-mcp](https://github.com/Boulea7/agy-mcp)，本仓库安装源为 [TuWeiZhi/agy-mcp](https://github.com/TuWeiZhi/agy-mcp)；注册名 `agy`，主工具 `mcp__agy__agy`）。仍在使用旧 Gemini MCP 的用户，请按以下步骤迁移。

### 1. 移除已废弃的 Gemini MCP

无论之前安装的是上游 `GuDaStudio/geminimcp` 还是本仓库归档的 fork `TuWeiZhi/geminimcp`，它们注册的 server 名均为 `gemini`，统一移除：

```bash
claude mcp remove gemini
```

> 说明：`TuWeiZhi/geminimcp`（fork 自 `GuDaStudio/geminimcp`）随 Gemini CLI 一同废弃，仅作历史归档保留，不再用于本工作流。

### 2. 安装 Agy MCP

Gemini MCP 移除后，按上方「二、快速开始 → 2.5」的命令安装 **Agy MCP**——它正是用来替代 Gemini 的前端/UI 多模型后端（uv 安装、验证、PyPI 备选说明均在 §2.5）。

### 3. 放行与全局提示词

- 在 `~/.claude/settings.json` 的 `allow` 中，把 `mcp__gemini__gemini` 替换为 `mcp__agy__agy`。
- 在 `~/.claude/CLAUDE.md` 的全局协议中，将所有 "Gemini" 替换为 "Agy"（见上方「配置全局提示词」）。
- agy-mcp 同样支持基于 `SESSION_ID` 的多轮对话，并提供 `mode=prototype`（仅产出 unified diff patch、不落盘）的调用方式，天然契合本项目"外部模型仅作原型参考、严禁写文件"的沙箱协议。

### 4. 工具映射对照

| 旧（已废弃） | 新 | 说明 |
|------|------|------|
| `mcp__gemini__gemini` | `mcp__agy__agy` | 前端/UI 原型与多模型 review 的主入口 |
| server `gemini` | server `agy` | `claude mcp` 注册名 |
| `geminimcp`（Gemini CLI 包装） | `agy-mcp`（Antigravity CLI 包装） | 底层 CLI 从 gemini 切到 agy |

> agy-mcp 共暴露 11 个 typed 工具（`agy` / `agy_continue` / `agy_start` / `agy_status` / `agy_read` / `agy_result` / `agy_cancel` / `agy_sessions` / `agy_doctor` / `agy_install_skill` / `agy_purge`）。本项目工作流仅以主工具 `agy` 对等替换原 `gemini`，其余工具按需使用。

---

## FAQ

<details>
<summary>Q1: 什么是 OpenSpec？</summary>

OpenSpec 是一个规范化的需求-实现工作流框架，通过结构化的约束集管理，确保从需求到代码的可追溯性和一致性。

</details>

<details>
<summary>Q2: 必须安装 Codex/Agy MCP 吗？如何安装？</summary>

不是必须的，但要用多模型协作就需要。完整安装命令见上方「二、快速开始 → 2.5」；从旧版 Gemini MCP 升级见「四、迁移指南」。`/gudaspec:init` 会检测并提示安装。

</details>

<details>
<summary>Q3: 约束集有什么作用？</summary>

约束集将需求转化为具体的技术限制条件，消除实现阶段的决策点。每个约束都缩小解空间，使实现阶段成为纯机械执行，无需即时判断。

</details>

---

## 许可证

本项目采用 [MIT License](LICENSE) 开源协议。

Copyright (c) 2025 [guda.studio](mailto:gudaclaude@gmail.com)

---

<div align="center">

## 用 🌟 为本项目助力~

[![Star History Chart](https://api.star-history.com/svg?repos=TuWeiZhi/commands&type=date&legend=top-left)](https://www.star-history.com/#TuWeiZhi/commands&type=date&legend=top-left)

</div>

