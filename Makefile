.PHONY: test

export USECASE

#test_extended:

test:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/$(USECASE) ./acr_test.go

#test_local:
