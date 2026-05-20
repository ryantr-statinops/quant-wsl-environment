# Quant WSL Environment

## What is this?

A high-performance development workspace optimized for quantitative finance and data science on WSL2 Ubuntu.

## What's included?

- **Production-ready terminal**: Zsh, Tmux, and system tools pre-configured for seamless workflow
- **Python 3.12 environment**: Pre-built with libraries for data ingestion (vnstock, yfinance), modeling (statsmodels, arch), and backtesting (vectorbt, quantstats)

## 📸 Workspace Preview

> **TIP**
> 
> **SCREENSHOT INSTRUCTION 1:**
> 
> Khang mở tmux lên, chia đôi màn hình (Split Pane):
> - Bên trái chạy một đoạn script backtest nhỏ bằng vectorbt hoặc in dữ liệu vnstock.
> - Bên phải mở btop để hiển thị biểu đồ tài nguyên CPU/RAM hệ thống.
> 
> Chụp lại tấm hình đó, đặt tên là `workspace_preview.png` rồi lưu vào thư mục dự án.

## 📐 Hybrid Architecture

The workspace is split into two clean layers to ensure reproducibility and keep the host system isolated:

```
┌────────────────────────────────────────────────────────┐
│               QUANT-WSL-ENVIRONMENT                    │
└────────────────────────────────────────────────────────┘
                            │
         ┌──────────────────┴──────────────────┐
         ▼                                     ▼
┌─────────────────────────────────┐ ┌─────────────────────────────────┐
│     OS-Level Tools (APT)        │ │      Quant Virtual Env          │
│  (Zsh, Tmux, Fzf, Btop, Gh)     │ │        (Micromamba)             │
└─────────────────────────────────┘ └─────────────────────────────────┘
                                                 │
                            ┌────────────────────┼────────────────────┐
                            ▼                    ▼                    ▼
                   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
                   │   Data Ingest   │  │ Analytics/Math  │  │   Backtesting   │
                   │(Vnstock,Yfinance│  │(Pandas, Stats-  │  │(VectorBT, Quant-│
                   │ Beautiful Soup) │  │models, Arch-GARCH)│  │    Stats)       │
                   └─────────────────┘  └─────────────────┘  └─────────────────┘
```

## 🛠️ Featured Tooling Stack

### 1. Terminal & Workspace Productivity

- **Zsh & Multi-plugins**: Configured with syntax highlighting, auto-suggestions, and customized prompts for high-speed terminal navigation.

- **Tmux (Warm Accent Theme)**: Optimized for multi-tasking, allowing seamless splitting of sessions between scraping scripts, running backtests, and system monitoring.

- **Fzf & Btop**: Interactive fuzzy searching and modern real-time system resource management.

### 2. Quantitative & Data Science Stack (Python 3.12)

Managed efficiently via Micromamba for blazing-fast environment resolution:

- **Backtesting & Evaluation**: 
  - vectorbt for matrix-based, high-performance vectorized backtesting
  - quantstats for portfolio risk metrics (Sharpe, Sortino, Max Drawdown)

- **Financial Modeling & Analytics**: 
  - statsmodels (Econometrics & Cointegration)
  - arch (GARCH models for volatility clustering)
  - pandas-ta (Technical analysis indicators)

- **Data Sources**: 
  - vnstock for seamless Vietnamese market financial data ingestion
  - yfinance for global assets (Forex, XAUUSD, Crypto)

- **Core Machine Learning**: 
  - scikit-learn and scipy for statistical and clustering models

## 🚀 Quick Start & Installation

Follow these steps to deploy the workspace on a fresh or existing WSL2 Ubuntu distribution.

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-username/quant-wsl-environment.git
cd quant-wsl-environment
```

### Step 2: Run the Automation Setup Script

Execute the bundled script to link your dotfiles, audit system packages, and build the Python environment automatically:

```bash
chmod +x setup.sh
./setup.sh
```

> **NOTE**
> 
> **SCREENSHOT INSTRUCTION 2:**
> 
> Sau khi Khang chạy lệnh `./setup.sh` thành công, terminal sẽ in ra các dòng thông báo log có màu kèm dòng THIẾT LẬP HOÀN TẤT!.
> 
> Hãy chụp lại màn hình terminal lúc đó, đặt tên là `setup_log.png` để người xem hình dung được quá trình cài đặt tự động mượt mà như thế nào.

### Step 3: Apply Changes & Verify

Reload your terminal session to step into your new workspace and verify the active environment:

```bash
exec zsh
micromamba activate quant_env
micromamba list
```

## 🔒 Security & Privacy Practices

- **Zero Hardcoded Credentials**: No API Keys (e.g., Binance, Vietstock) or Git tokens are tracked in this repository.

- **Strict Git Filtering**: Local databases, backtest caches (`.ipynb_checkpoints`, `__pycache__`), and large data assets (`.csv`, `.parquet`) are strictly filtered out via `.gitignore` to prevent repository bloating and data leaks.

## 📄 License

Distributed under the MIT License. See LICENSE for more information.