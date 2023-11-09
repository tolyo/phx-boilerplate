frontend.clean:
	@rm -rf node_modules
	@rm -rf deps
	@rm -rf _build

frontend.setup:
	@echo $(INFO) "Installing NPM dependencies..."
	@npm i web
	@npx playwright install

frontend.start:
	@echo $(INFO) "Starting browsersync ..."
	@npm run browsersync

frontend.lint:
	@echo $(INFO) "Formatting Js/CSS"
	@npm run format
	@echo $(INFO) "Linting Js"
	@npm run lint

frontend.check:
	@echo $(INFO) "Typechecking Js"
	@npm run typecheck

frontend.test:
	@echo $(INFO) "Playwright test JS"
	@npm run playwright