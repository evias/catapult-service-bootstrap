current_dir = $(shell pwd)

start:
	@echo ''
	@echo 'Now starting nem2 containers..'
	docker-compose up -d

start-with-explorer:
	@echo ''
	@echo 'Now starting nem2 containers with Explorer..'
	docker-compose -f docker-compose-with-explorer.yml up

stop:
	@echo ''
	@echo 'Now stopping nem2 containers..'
	docker-compose down --remove-orphans --timeout 120

clean:
	@echo ''
	@echo 'Now cleaning nem2 data..'
	sh clean-data

reset:
	@echo ''
	@echo 'Now resetting nem2..'
	sh clean-all

rebuild:
	@echo ''
	@echo 'Now rebuilding containers..'
	docker-compose up --build -d
