#! /bin/bash -i
set -E
source <(curl -s https://raw.githubusercontent.com/rangapv/bash-source/main/s1.sh) >>/dev/null 2>&1

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
echo "export GOPATH=\$(go env GOPATH)" >> ~/.bashrc
echo "export PATH=\$GOPATH/bin:\$PATH" >> ~/.bashrc

eval "source ~/.bashrc"
PS1='$ '     
bi=$(source ~/.bashrc)
rbi=$(echo "$?")
if [ $rbi = "0" ]
then
eval "echo GOROOT is $GOROOT"
eval "echo GOPATH is $GOPATH"
fi
}


govercheck() {

gflag=0
gov=`which go`
govs="$?"
if [[ ( $govs -eq 0 ) ]]
then
	gflag=1
fi
 
vergo=`go version`
vergos="$?"
gvflag=0
if [[ ( $vergos -eq 0 ) ]]
then
        gvflag=1
        curver1=`go version | awk '{split($0,a," "); printf a[3]}' | awk '{split($0,b,".");print b[1]}'`
	curver11=${curver1:2}
        curver=`go version | awk '{split($0,a," "); printf a[3]}' | awk '{split($0,b,".");print b[2]}'`
	versiongo=$curver11.$curver
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



elif [[ ! -z "$r1" || ! -z "$c1" || ! -z "$a1" ]]
then
        ji=$(cat /etc/*-release | grep '^ID=' |awk '{split($0,a,"\"");print a[2]}')
        ki="${ji,,}"
        if [ $ki = "amzn" ]
        then
           echo "It is amazon AMI"
        elif [ $ki = "rhel" ]
        then
           echo "It is RHEL"
        elif [ $ki = "centos" ]
        then
           echo "It is centos"
        else
           echo "OS flavor cant be determined"
        fi
  	cm1="yum"
        if [ true ]
	then
        link=$(readlink -f `which /usr/bin/python`)
	sudo ln -sf /usr/bin/python2 /usr/bin/python
	sudo $cm1 -y update
        sudo $cm1 -y install wget
	sudo ln -sf $link /usr/bin/python 
	fi
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
#        sudo $cm1 -y update
        sudo $cm1 -y install wget
        count=1
else
echo "The distribution cannot be determined"
fi

echo "What version of go is required 1.14/1.15/1.16 "
read gover
govercheck


if [[ (( $gover > $versiongo )) ]]
then
  if [[ (( $gover = 1.15  )) ]]
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
  elif [[ (( $gover = 1.16 )) ]]
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
else
	echo "Go requiremnet is already satisifed Nothing to Install / Upgrade"
        echo "$gov"
	echo "$vergo"
fi
