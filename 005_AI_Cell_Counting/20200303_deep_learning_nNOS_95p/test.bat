@echo on
set root=C:\ProgramData\Anaconda3
call %root%\Scripts\activate.bat C:\Users\smartBrain20cores\.conda\envs\bhmagic_tf_2_0_beta
python "brain.py"
