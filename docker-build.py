#!/usr/bin/python3

from optparse import OptionParser
import os

def menu():
    parser = OptionParser()
    parser.add_option("-b", "--build", 
                      help="build sdk image", action="store_true")
    parser.add_option("-e", "--build-helloworld-example",
                     help="build helloworld example", action="store_true")
    parser.add_option("-w", "--build-walker-example",
                     help="build walker example", action="store_true")  
    parser.add_option("-p", "--build-png2snes-example",
                     help="build png2snes example", action="store_true")                                        
    parser.add_option("-r", "--run-image",
                     help="run sdk image", action="store_true")                     
    
    (options, args) = parser.parse_args()

    for option in vars(options):
        value =  getattr(options, option)
        if option == 'build' and value == True:
            build_image()
        elif option == 'build_helloworld_example' and value == True:  
            build_helloworld_example()    
        elif option == 'build_walker_example' and value == True:  
            build_walker_example()                
        elif option == 'build_png2snes_example' and value == True:  
            build_png2snes_example()    
        elif option == 'run_image' and value == True:  
            run_image()            

def build_image():
    os.system('docker build . -f Dockerfile -t fabiosoaza/snes-dev-tools:latest')    

def run_image():
    os.system('docker run -it -v $(pwd)/examples:/tmp/examples fabiosoaza/snes-dev-tools:latest bash')    

def build_walker_example():
     os.system('docker run -v $(pwd)/examples/Neviksti/walker-example:/tmp/walker-example fabiosoaza/snes-dev-tools:latest bash -c "cd /tmp/walker-example/ && ./build_game.sh"')

def build_helloworld_example():
     os.system('docker run -v $(pwd)/examples/hello-world:/tmp/hello-world fabiosoaza/snes-dev-tools:latest bash -c "cd /tmp/hello-world/ && ./build.sh HelloWorld"')

def build_png2snes_example():
     os.system('docker run -v $(pwd)/examples/png2snes/hello-world:/tmp/png2snes-hello-world fabiosoaza/snes-dev-tools:latest bash -c "cd /tmp/png2snes-hello-world/ && make"')

menu()
