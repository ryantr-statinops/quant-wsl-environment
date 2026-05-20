#!/usr/bin/env bash

# Thoát ngay lập tức nếu có lệnh nào bị lỗi
set -e

# Khai báo màu sắc cho terminal thêm phần chuyên nghiệp
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}====================================================${NC}"
echo -e "${ORANGE}   Bắt đầu cấu hình không gian làm việc Quant WSL   ${NC}"
echo -e "${BLUE}====================================================${NC}"

# 1. Liên kết các file cấu hình (Symlinking)
echo -e "\n${BLUE}[1/3] Thiết lập các liên kết cấu hình (Dotfiles)...${NC}"
REPO_DIR=$(pwd)

# Sao lưu cấu hình cũ nếu có để tránh mất dữ liệu của người dùng
for file in .zshrc .tmux.conf; do
    if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        echo -e "${ORANGE}Đang sao lưu file $file hiện tại thành $file.bak...${NC}"
        mv "$HOME/$file" "$HOME/$file.bak"
    fi
done

# Tạo liên kết động từ thư mục repo ra thư mục gốc HOME
ln -sf "$REPO_DIR/dotfiles/.zshrc" "$HOME/.zshrc"
ln -sf "$REPO_DIR/dotfiles/.tmux.conf" "$HOME/.tmux.conf"
echo -e "${GREEN}✓ Đã liên kết xong .zshrc và .tmux.conf!${NC}"

# 2. Kiểm tra và nhắc nhở cài đặt các gói hệ thống cốt lõi
echo -e "\n${BLUE}[2/3] Kiểm tra các công cụ hệ thống (system dependencies)...${NC}"
REQUIRED_PKG=("tmux" "zsh" "fzf" "btop" "curl" "git" "gh")
MISSING_PKG=()

for pkg in "${REQUIRED_PKG[@]}"; do
    if ! command -v "$pkg" &> /dev/null; then
        MISSING_PKG+=("$pkg")
    fi
done

if [ ${#MISSING_PKG[@]} -ne 0 ]; then
    echo -e "${ORANGE}Phát hiện thiếu một số gói hệ thống: ${MISSING_PKG[*]}${NC}"
    echo -e "Vui lòng cài đặt bằng cách chạy: ${BLUE}sudo apt update && sudo apt install -y ${MISSING_PKG[*]}${NC}"
else
    echo -e "${GREEN}✓ Tất cả gói phần mềm cốt lõi đã được cài đặt đầy đủ!${NC}"
fi

# 3. Khởi tạo môi trường ảo Python bằng Micromamba
echo -e "\n${BLUE}[3/3] Thiết lập môi trường Python (Micromamba)...${NC}"
if command -v micromamba &> /dev/null; then
    if [ -f "$REPO_DIR/environment/environment.yml" ]; then
        echo -e "${ORANGE}Đang khởi tạo môi trường 'quant_env' từ file environment.yml...${NC}"
        micromamba env create -f "$REPO_DIR/environment/environment.yml" -y || true
        echo -e "${GREEN}✓ Hoàn tất cấu hình môi trường ảo!${NC}"
    else
        echo -e "${ORANGE}Không tìm thấy file environment/environment.yml. Bỏ qua bước này.${NC}"
    fi
else
    echo -e "${ORANGE}Không tìm thấy Micromamba trên hệ thống này.${NC}"
    echo -e "Hãy cài đặt Micromamba trước nếu muốn tự động dựng môi trường 'quant_env'.${NC}"
fi

echo -e "\n${GREEN}====================================================${NC}"
echo -e "${GREEN}        THIẾT LẬP HOÀN TẤT! HÃY CHẠY: exec zsh       ${NC}"
echo -e "${GREEN}====================================================${NC}\n"