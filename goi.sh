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
wg=$gover$gover2
sudo wget "$wg"
tar -xzf $gover2
se3=$( echo "${gover2}" | awk '{split($0,a,".");print a[1]"."a[2]}')
sudo rm -Rf /usr/local/go
sudo mv go /usr/local 
echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export PATH=\$GOROOT/bin:\$PATH" >> ~/.bashrc
eval "source ~/.bashrc"
PS1='$ '     
bi=$(source ~/.bashrc)
rbi=$(echo "$?")
if [ $rbi = "0" ]
then
eval "echo GOROOT is $GOROOT"
fi
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
        sudo add-apt-repository -y  ppa:gophers/archive
        sudo apt-get -y update
        count=1

elif [ ! -z "$r1" ]
then
        echo "it is a RHEL"
        ji=$(cat /etc/*-release | grep '^ID=' |awk '{split($0,a,"\"");print a[2]}')
        ki="${ji,,}"
        cm1="yum -y"
        sudo $cm1 update
        sudo yum -y install wget

#        sudo yum -y install gcc make openssl-devel bzip2-devel libffi-devel zlib-devel wget
#        sudo yum -y install @development
        count=1

elif [ ! -z "$f1" ]
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
elif [ ! -z "$c1" ]
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
else
echo "The distribution cannot be determined"
fi

echo "What version of go is required 1.14/1.15/1.16 "
read gover

if [ $count > 0 ]
then

  if [ $gover = "1.15" ]
  then
     echo "Installing go 1.15"
     goupgrade https://dl.google.com/go/ go1.15.2.linux-amd64.tar.gz 
     PS1='$ '     
     bi=$(source ~/.bashrc)
     rbi=$(echo "$?")
     if [ $rbi = "0" ]
     then  
     eval "echo $(go version)" 
     fi
  elif [ $gover = "1.16" ]
  then
     echo "Installing go 1.16"
     goupgrade https://dl.google.com/go/ go1.16.3.linux-amd64.tar.gz
     PS1='$ '     
     bi=$(source ~/.bashrc)
     rbi=$(echo "$?")
     echo "installing 1.16 rbi is $rbi"
     if [ $rbi = "0" ]
     then
     eval "echo $(go version)"
     fi
  else
   echo "go-version not available"	  
  fi

fi


