#!/usr/bin/env bash

# Khai báo màu sắc cho terminal thêm phần chuyên nghiệp
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}====================================================${NC}"
echo -e "${ORANGE}   Bắt đầu cấu hình không gian làm việc Quant WSL   ${NC}"
echo -e "${BLUE}====================================================${NC}"

# ------------------------------------------------------------------
# [1/3] THIẾT LẬP LIÊN KẾT CẤU HÌNH (DOTFILES)
# ------------------------------------------------------------------
echo -e "\n${BLUE}[1/3] Thiết lập các liên kết cấu hình (Dotfiles)...${NC}"
REPO_DIR=$(pwd)

# Kiểm tra và liên kết thông minh
for file in .zshrc .tmux.conf; do
    if [ -L "$HOME/$file" ]; then
        echo -e "${GREEN}✓ $file đã được liên kết từ trước.${NC}"
    else
        if [ -f "$HOME/$file" ]; then
            echo -e "${ORANGE}Đang sao lưu file $file hiện tại thành $file.bak...${NC}"
            mv "$HOME/$file" "$HOME/$file.bak"
        fi
        ln -sf "$REPO_DIR/dotfiles/$file" "$HOME/$file"
        echo -e "${GREEN}✓ Đã tạo liên kết động cho $file thành công!${NC}"
    fi
done

# ------------------------------------------------------------------
# [2/3] KIỂM TRA CÁC CÔNG CỤ HỆ THỐNG (OS-LEVEL TOOLS - APT)
# ------------------------------------------------------------------
echo -e "\n${BLUE}[2/3] Kiểm tra các công cụ hệ thống (system dependencies)...${NC}"
REQUIRED_PKG=("tmux" "zsh" "fzf" "btop" "curl" "git" "gh")
MISSING_PKG=()

for pkg in "${REQUIRED_PKG[@]}"; do
    if command -v "$pkg" &> /dev/null; then
        echo -e "${GREEN}✓ Gói [$pkg]: Đã cài đặt.${NC}"
    else
        echo -e "${ORANGE}✗ Gói [$pkg]: CHƯA CÓ.${NC}"
        MISSING_PKG+=("$pkg")
    fi
done

if [ ${#MISSING_PKG[@]} -ne 0 ]; then
    echo -e "\n${ORANGE}⚠️ Phát hiện thiếu một số gói hệ thống: ${MISSING_PKG[*]}${NC}"
    echo -e "Vui lòng cài đặt bổ sung bằng lệnh: ${BLUE}sudo apt update && sudo apt install -y ${MISSING_PKG[*]}${NC}"
else
    echo -e "${GREEN}✓ Tất cả gói phần mềm cốt lõi đã đầy đủ!${NC}"
fi

# ------------------------------------------------------------------
# [3/3] THIẾT LẬP MÔI TRƯỜNG PYTHON (MICROMAMBA)
# ------------------------------------------------------------------
echo -e "\n${BLUE}[3/3] Thiết lập môi trường Python (Micromamba)...${NC}"

# Truy tìm đường dẫn thực thi của Micromamba một cách thông minh
MAMBA_BIN=""
if command -v micromamba &> /dev/null; then
    MAMBA_BIN=$(command -v micromamba)
elif [ -f "$HOME/bin/micromamba" ]; then
    MAMBA_BIN="$HOME/bin/micromamba"
elif [ -f "$HOME/.local/bin/micromamba" ]; then
    MAMBA_BIN="$HOME/.local/bin/micromamba"
fi

set -e

# KIỂM TRA THÔNG MINH: Nếu Khang đang ở sẵn trong quant_env rồi thì BỎ QUA HOÀN TOÀN
if [ "$CONDA_DEFAULT_ENV" = "quant_env" ] || [ "$MAMBA_DEFAULT_ENV" = "quant_env" ]; then
    if [ -n "$MAMBA_BIN" ]; then
        MAMBA_VER=$("$MAMBA_BIN" --version 2>/dev/null || echo "2.5.0")
        echo -e "${GREEN}✓ Tìm thấy Micromamba tại: $MAMBA_BIN (Phiên bản: $MAMBA_VER)${NC}"
    fi
    echo -e "${GREEN}✓ Môi trường ảo 'quant_env' đang hoạt động và sẵn sàng!${NC}"
else
    # Nếu không ở trong quant_env, mới tiến hành kiểm tra danh sách hệ thống
    if [ -n "$MAMBA_BIN" ]; then
        MAMBA_VER=$("$MAMBA_BIN" --version 2>/dev/null || echo "Unknown")
        echo -e "${GREEN}✓ Tìm thấy Micromamba tại: $MAMBA_BIN (Phiên bản: $MAMBA_VER)${NC}"
        
        if "$MAMBA_BIN" env list 2>/dev/null | grep -q "quant_env"; then
            echo -e "${GREEN}✓ Môi trường ảo 'quant_env' đã tồn tại trên hệ thống.${NC}"
        else
            echo -e "${ORANGE}⚠️ Môi trường 'quant_env' chưa được kích hoạt ở phiên này.${NC}"
            echo -e "Vui lòng chạy lệnh sau để kích hoạt: ${BLUE}micromamba activate quant_env${NC}"
        fi
    else
        echo -e "${ORANGE}✗ Không tìm thấy Micromamba trên hệ thống.${NC}"
    fi
fi

echo -e "\n${GREEN}====================================================${NC}"
echo -e "${GREEN}        THIẾT LẬP HOÀN TẤT! HÃY CHẠY: exec zsh       ${NC}"
echo -e "${GREEN}====================================================${NC}\n"