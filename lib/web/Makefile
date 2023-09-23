frontend.clean:
	@rm -rf node_modules
	@rm -rf deps
	@rm -rf _build
	@rm package-lock.json

frontend.setup:
	@echo $(INFO) "Installing NPM dependencies..."
	@npm i web

frontend.lint:
	@echo $(INFO) "Formatting Js/CSS"
	@npm run format
	@echo $(INFO) "Linting Js"
	@npm run lint

frontend.check:
	@echo $(INFO) "Typechecking Js"
	@npm run typecheck
