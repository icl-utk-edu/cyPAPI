build: setup.py papi/cypapi.pyx papi/papih.pxd
	python setup.py build_ext --inplace

install:
	pip install -v .

clean:
	rm -rf *.so build/ *.egg-info/
	make -C papi clean

docs:
	sphinx-build -M html docs/source/ docs/build/
