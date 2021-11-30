
default:
	@godep go build
	@ls -ltrh

setup: 
	@echo Installing developer tooling, godep and reflex
	go install github.com/tools/godep@latest
	go install github.com/cespare/reflex/...@latest
	go install golang.org/x/tools/cgmd/cover@latest
	go install github.com/vektra/mockery/...@latest

.goxc.ok:
	@echo Installing crossbuild tooling. This will take a while...
	go get github.com/laher/goxc
	goxc -t
	touch .goxc.ok

watch:
	@reflex -g '*.go' make test

test:
	@godep go test -coverprofile=c.out

coverage: test
	@godep go tool cover -html=c.out

bump:
	@goxc bump

release: .goxc.ok
	godep save
	goxc

mocks:
	@mockery -name Converter

brew_sha:
	@shasum -a 256 $(ver)/blade_$(ver)_darwin_amd64.zip
.PHONY: default test setup release watch coverage mocks bump brew_sha

