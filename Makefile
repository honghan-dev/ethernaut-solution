-include .env

.PHONY: all script clean

ANVIL_PRIVATE_KEY := $(PRIVATE_KEY)
ANVIL_RPC := $(ANVIL_RPC_URL)

# Install Foundry if not already installed
install:
	@echo "Checking for Foundry installation..."
	@if [ -x "$$(command -v forge)" ]; then \
		echo "Foundry is already installed."; \
	else \
		echo "Installing Foundry..."; \
		curl -L https://foundry.paradigm.xyz | bash; \
		source ~/.bashrc; \
		foundryup; \
	fi

# Launch attack script
script:
	@echo "Script: $(FILENAME).s.sol"
	@forge script script/$(FILENAME).s.sol:$(FILENAME) -vvvv --broadcast --rpc-url $(ANVIL_RPC) --private-key $(ANVIL_PRIVATE_KEY)

# Clean target
clean:
	@echo "Cleaning up..."
	rm -rf out