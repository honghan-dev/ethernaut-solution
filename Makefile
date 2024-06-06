-include .env

.PHONY: all script clean

ANVIL_PRIVATE_KEY := $(PRIVATE_KEY)
ANVIL_RPC := $(ANVIL_RPC_URL)

github:
	@git add .
	@git commit -m "$(MSG)"

# Launch attack script
script:
	@echo "Script: $(FILENAME).s.sol"
	@forge script script/$(FILENAME).s.sol:$(FILENAME) -vvvv --broadcast --rpc-url $(ANVIL_RPC) --private-key $(ANVIL_PRIVATE_KEY)

# Clean target
clean:
	@echo "Cleaning up..."
	rm -rf out