#!/bin/bash
#docker exec neon-full-tests-1 bash -c 'sed -i "/pytest.mark.skip/d" `find integration/tests | grep -e ".py$"`'
docker exec -it neon-full-tests-1 bash -c "pytest integration/tests/$1 --network docker_net --numprocesses 1"
