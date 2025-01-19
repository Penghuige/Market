.PHONY: clean all submit clean_data run

# 自定义环境变量
CC = g++ # 指定编译器
CFLAGS = -I include # 指定头文件目录

# 文件匹配
CFILES = $(shell find src -name "*.c")
CPPFILES = $(shell find src -name "*.cpp")
OBJS = $(CFILES:.c=.o) $(CPPFILES:.cpp=.o)
TARGET_DIR = bin
TARGET = $(TARGET_DIR)/main

# 删除命令
RM = rm -f

# 进度记录相关
DEVICE = Linux-PC
STUNAME = Penghui
GITFLAGS = -q --author='tracer<Penghui@Linux-PC>' --no-verify --allow-empty

# Git 提交函数
define git_commit
	-@while (test -e .git/index.lock); do sleep 0.1; done
	-@(echo "> $(1)" && echo $(DEVICE) $(STUNAME) && uname -a && uptime) | git commit -F - $(GITFLAGS)
	-@sync
endef

# 提交到 GitHub 仓库
submit:
	git remote set-url origin git@github.com:Penghuige/Market.git
	git add . --ignore-errors
	-@while (test -e .git/index.lock); do sleep 0.1; done
	git commit -m "Automated submission"
	git push origin main

# 默认目标
all: $(TARGET)

# 链接目标
$(TARGET): $(OBJS)
	$(CC) -o $(TARGET) $(OBJS)
	@$(call git_commit, "Auto-commit")

# 编译规则
bin/%.o: src/%.cpp
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

bin/%.o: src/%.c
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

# 清理目标
clean:
	$(RM) $(TARGET) $(OBJS)

clean_data:
	$(RM) $(DATA)

run: all
	@$(TARGET)
