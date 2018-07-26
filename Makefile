
RUBY_FXGEN_IMAGE=jgensl2/ruby-fxgen-builder
RUBY_FXGEN_TAG=v2.0.0

clean:
	rm -rf output

package: clean
	docker run --rm -v $$PWD:/workdir -v $$PWD/output:/output ${RUBY_FXGEN_IMAGE}:${RUBY_FXGEN_TAG}
