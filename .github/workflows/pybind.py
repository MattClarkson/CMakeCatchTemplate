name: Build with Boost

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v1
    - name: make build dir
      run:  mkdir build
    - name: cmake
      run: cd build; cmake .. -DBUILD_Python_PyBind=ON
    - name: make
      run: cd build; make
    - name: run tests
      run: build/MYPROJECT-build/bin/mpBasicTest
      
     
     -name: install python module
      run:  python setup.py install
     
     -name: run python code
      run:  python -c 'import CMakeCatchTemplatePython as myC; x = myC.my_first_add_function(4,6); print(x)'
