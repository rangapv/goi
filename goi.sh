#! /bin/bash
set -E

li=$(uname -s)
if [ $(echo "$li" | grep Linux) ]
then
  mac=""
else
  mac=$(sw_vers | grep Mac)
fi


if [ -z "$mac" ]
then
  u1=$(cat /etc/*-release | grep ID= | grep ubuntu)
  f1=$(cat /etc/*-release | grep ID= | grep fedora)
  r1=$(cat /etc/*-release | grep ID= | grep rhel)
  c1=$(cat /etc/*-release | grep ID= | grep centos)
  s1=$(cat /etc/*-release | grep ID= | grep sles)
  d1=$(cat /etc/*-release | grep ID= | grep debian)
else
  echo "Mac is not empty"
fi

count=0

goupgrade() {
gargs="$#"
args=("$@")
arg1=${args[$((pargs-1))]}
gover=${args[$((gargs-gargs))]}
gover2=${args[$((gargs-$((gargs-1))))]}
gover3=${args[$((gargs-$((gargs-2))))]}
var3="/"
wg=$gover$gover2$var3$gover3
sudo wget "$wg"
tar xzf $pyver3
se1=$( echo "${pyver3}" | awk '{split($0,a,".");print a[1]"."a[2]"."a[3]}')
se2=$( echo "${pyver3}" | awk '{split($0,a,".");print a[1]"."a[2]}')
se3=$( echo "${pyver2}" | awk '{split($0,a,".");print a[1]"."a[2]}')
cd $se1
sudo ./configure --enable-optimizations
sudo make altinstall
slpy="python$se3"
sudo ln -sf "/usr/local/bin/$slpy" /usr/bin/python
}


if [ ! -z "$u1" ]
then 
	mi=$(lsb_release -cs)
	mi2="${mi,,}"
	ji=$(cat /etc/*-release | grep DISTRIB_ID | awk '{split($0,a,"=");print a[2]}')
	ki="${ji,,}"

	if [ "$ki" == "ubuntu" ]
	then
   	echo "IT IS UBUNTU"
	fi
        echo " What version of go is required 1.8 / 1.9 "
        read gover
        sudo add-apt-repository ppa:gophers/archive
        sudo apt-get -y update
        sudo apt-get -y install golang-$gover
        echo " " >> ~/.bashrc
        echo "export PATH=$PATH:/usr/lib/go-$gover/bin" >> ~/.bashrc
        echo "export GOPATH=~/go" >> ~/.bashrc
        echo "GO Installed Pls logout re-login or in a new shell to test type \"go version\" "
fi


if [ ! -z "$f1" ]
then
        ji=$(cat /etc/*-release | grep '^ID=' |awk '{split($0,a,"=");print a[2]}')
        ki="${ji,,}"
        echo "IT IS FEDORA"
        echo " What version of go is required for Fedora 1.7/1.8/1.9/1.10/1.11 "
        read gover
        sudo yum -y update
        sudo yum -y install wget
        wget https://storage.googleapis.com/golang/go$gover.linux-amd64.tar.gz
        tar -xvf go$gover.linux-amd64.tar.gz
        sudo mv go /usr/local
        echo " " >> ~/.bashrc
        echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
        echo "export GOPATH=~/go" >> ~/.bashrc
        echo "GO Installed Pls logout re-login or in a new shell to test type \"go version\" "
fi

if [ ! -z "$c1" ]
then
	echo "IT IS CENTOS"
        ji=$(cat /etc/*-release | grep '^ID=' |awk '{split($0,a,"\"");print a[2]}')
        ki="${ji,,}"
	echo " What version of go is required for Fedora 1.7/1.8/1.9/1.10/1.11 "
        read gover
        sudo yum -y update
        sudo yum -y install wget
        wget https://storage.googleapis.com/golang/go$gover.linux-amd64.tar.gz
        tar -xvf go$gover.linux-amd64.tar.gz
        sudo mv go /usr/local
	echo " " >> ~/.bashrc
        echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
        echo "export GOPATH=~/go" >> ~/.bashrc
        echo "GO Installed Pls logout re-login or in a new shell to test type \"go version\" "
fi
