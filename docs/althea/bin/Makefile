#!/usr/bin/env make

define get-chip-architecture =
$(shell lscpu | grep 'Vendor ID' | awk '{print $$NF}')
endef

# https://stackoverflow.com/a/62087619/1294308
define get-rand-str =
$(shell tr -dc A-Za-z </dev/urandom | head -c 12)
endef

export ALTHEA_BINARY_VERSION ?= v0.0.1
export ALTHEA_CHAIN_ID ?= althea-testnet1v2
export ALTHEA_MONIKER := $(call get-rand-str)
# export ALTHEA_VALIDATOR_KEYNAME = $(ALTHEA_MONIKER)-keyname

ALTHEA_CHIP_ARCHITECTURE ?= $(get-chip-architecture)

download-binaries:
	@if [ ! -d "$$HOME/bin" ]; then\
		mkdir "$$HOME/bin";\
	fi
	if [ "$(ALTHEA_CHIP_ARCHITECTURE)" = "ARM" ]; then\
		wget -O $$HOME/bin/althea https://github.com/althea-net/althea-chain/releases/download/$(ALTHEA_BINARY_VERSION)/althea-arm;\
		wget -O $$HOME/bin/client https://github.com/althea-net/althea-chain/releases/download/$(ALTHEA_BINARY_VERSION)/client-arm;\
		wget -O $$HOME/bin/orchestrator https://github.com/althea-net/althea-chain/releases/download/$(ALTHEA_BINARY_VERSION)/orchestrator-arm;\
		wget -O $$HOME/bin/register-delegate-keys https://github.com/althea-net/althea-chain/releases/download/$(ALTHEA_BINARY_VERSION)/register-delegate-keys-arm;\
		wget -O $$HOME/bin/relayer https://github.com/althea-net/althea-chain/releases/download/$(ALTHEA_BINARY_VERSION)/relayer-arm;\
	else\
		wget -O $$HOME/bin/althea https://github.com/althea-net/althea-chain/releases/download/$(ALTHEA_BINARY_VERSION)/althea;\
		wget -O $$HOME/bin/client https://github.com/althea-net/althea-chain/releases/download/$(ALTHEA_BINARY_VERSION)/client;\
		wget -O $$HOME/bin/orchestrator https://github.com/althea-net/althea-chain/releases/download/$(ALTHEA_BINARY_VERSION)/orchestrator;\
		wget -O $$HOME/bin/register-delegate-keys https://github.com/althea-net/althea-chain/releases/download/$(ALTHEA_BINARY_VERSION)/register-delegate-keys;\
		wget -O $$HOME/bin/relayer https://github.com/althea-net/althea-chain/releases/download/$(ALTHEA_BINARY_VERSION)/relayer;\
	fi
	chmod 755 $$HOME/bin/althea $$HOME/bin/client $$HOME/bin/orchestrator $$HOME/bin/register-delegate-keys $$HOME/bin/register-delegate-keys $$HOME/bin/relayer

generate-key:
	$$HOME/bin/althea init $$ALTHEA_MONIKER --chain-id $(ALTHEA_CHAIN_ID) >> keyfile-$$ALTHEA_MONIKER.json 2>&1
	$$HOME/bin/althea keys add $$ALTHEA_MONIKER
	@echo "\nYour Althea moniker is" $$ALTHEA_MONIKER
	@echo "Remember your password, save and secure your keyfile, keyfile-$$ALTHEA_MONIKER.json, and then run:"
	@echo "make provision-genesis-json"

provision-genesis-json:
	mv $$HOME/.althea/config/genesis.json $$HOME/.althea/config/genesis-`date +%F-%H%M`.json
	wget -O $$HOME/.althea/config/genesis.json https://github.com/althea-net/althea-chain/releases/download/$(ALTHEA_BINARY_VERSION)/althea-testnet1-v2-genesis.json
	@echo "Now start your althea validator so that it can begin to sync:"
	@echo "althea start"
	@echo "\nAsk for the current blockheight in the discord channel or chat."
	@echo "Copy and paste your address into the discord channel or chat to request tokens; find your address via this command:"
	@echo "althea keys list"
	@echo "\nRemember, your moniker is $$ALTHEA_MONIKER\n"
	@$$HOME/bin/althea keys list

# https://stackoverflow.com/a/13517811/1294308
add-persistent-peers:
	cp $$HOME/.althea/config/config.toml $$HOME/.althea/config/config-`date +%F-%H%M`.toml
	patch -b -i - $$HOME/.althea/config/config.toml < EOF
--- config-000.toml     2021-02-21 16:26:00.441878641 +0000
+++ config.toml 2021-02-21 16:32:49.708608552 +0000
@@ -184,7 +184,7 @@
seeds = ""

# Comma separated list of nodes to keep persistent connections to
-persistent_peers = ""
+persistent_peers = "05ded2f258ab158c5526eb53aa14d122367115a7@testnet1.althea.net:26656"

# UPNP port forwarding
upnp = false
EOF

# althea tx staking create-validator \
#   --amount=100000000ualtg \
#   --pubkey=$(althea tendermint show-validator) \
#   --moniker=rriehle \
#   --chain-id=althea-testnet1v2 \
#   --commission-rate="0.10" \
#   --commission-max-rate="0.20" \
#   --commission-max-change-rate="0.01" \
#   --min-self-delegation="1" \
#   --gas="auto" \
#   --gas-adjustment=1.5 \
#   --gas-prices="0.025ualtg" \
#   --from=rriehle

# To avoid unintended conflicts with file names, always add to .PHONY
# unless there is a reason not to.
# https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html
all: download-binaries generate-key provision-genesis-json
.PHONY : all