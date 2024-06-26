build: setup.py cypapi/cypapi.pyx cypapi/papih.pxd
	python setup.py build_ext --inplace

install:
	pip install -v .

clean:
	rm -rf *.so build/ *.egg-info/
	make -C cypapi clean

docs:
	sphinx-build -M html docs/source/ docs/build/
