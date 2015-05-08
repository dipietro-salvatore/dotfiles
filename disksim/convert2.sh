blkparse -i fb.blktrace.0  -f %T.%9t %m %9S %8n %d %a %C n | egrep I |  sed 's/R/1/' |  sed 's/W/0/' 
