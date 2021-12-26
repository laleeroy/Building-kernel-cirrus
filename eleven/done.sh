#!/usr/bin/env bash

export BOT_MSG_URL="https://api.telegram.org/bot$TG_TOKEN/sendMessage"
export BOT_MSG_URL2="https://api.telegram.org/bot$TG_TOKEN"

tg_post_msg() {
	curl -s -X POST "$BOT_MSG_URL" -d chat_id="$TG_CHAT_ID" \
	-d "disable_web_page_preview=true" \
	-d "parse_mode=html" \
	-d text="$1"

}

cd $pwd

com ()
{
    tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
}

time com ccache 1
rclone copy ccache.tar.gz NFS:ccache/kernel -P
rm -rf ccache.tar.gz 

curl -s -X POST "$BOT_MSG_URL2/sendSticker" \
-d sticker="CAACAgIAAx0CXjGT1gACAeVg69gXIw-a6h1nvmmaub51tQQwCgACLQMAAsbMYwIquW4nbs0crSAE" \
-d chat_id="$TG_CHAT_ID"
tg_post_msg "<b>Building Kernel :</b><code> success</code>%0A<b>Changelog :</b>https://github.com/NFS-projects/kernel_xiaomi_rosy/commits/eleven"
