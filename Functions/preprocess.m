function [traffic] = preprocess(file_addr, source)
cd ..
cd Data
cd(source)
traffic = readtable(file_addr);
traffic =traffic{:,:};
cd ..
cd ..
cd Functions
end