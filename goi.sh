#! /bin/bash -i
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
        
	if [ "$ki" = "ubuntu" ]
	then
   	echo "IT IS UBUNTU"
	fi
        sudo add-apt-repository -y  ppa:gophers/archive
        sudo apt-get -y update
        count=1



elif [ ! -z "$d1" ]
then
        mi=$(lsb_release -cs)
        mi2="{mi,,}"
	ji=$(cat /etc/*-release | grep ^NAME | awk '{split($0,a,"=");print a[2]}')
	jj=$(echo $ji | awk '{split($0,b," ");print b[1]}')
	jk=$(echo $jj | awk '{split($0,c,"\"");print c[2]}')
	ki="${jk,,}"
	if [ "$ki" = "debian" ]
	then
   	echo "IT IS Debian"
	fi
        sudo apt-get -y update
        count=1



elif [[ ! -z "$r1" || ! -z "$c1" ]]
then
        echo "it is a RHEL /Family"
        ji=$(cat /etc/*-release | grep '^ID=' |awk '{split($0,a,"\"");print a[2]}')
        ki="${ji,,}"
        cm1="yum -y"
        sudo $cm1 update
        sudo yum -y install wget
        count=1

elif [ ! -z "$s1" ]
then
	echo "it is a SuSE"
	cm1="zypper"
	sudo $cm1 install -y git wget make
        sudo $cm1 update -y
        count=1

elif [ ! -z "$f1" ]
then
        ji=$(cat /etc/*-release | grep '^ID=' |awk '{split($0,a,"=");print a[2]}')
        ki="${ji,,}"
        echo "IT IS FEDORA"
        cm1="dnf"
        sudo $cm1 -y update
        sudo $cm1 -y install wget
        count=1
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
     if [ $rbi = "0" ]
     then
     eval "echo $(go version)"
     fi
  else
   echo "go-version not available"	  
  fi

fi


