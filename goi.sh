#!/bin/bash -i
set -E
source <(curl -s https://raw.githubusercontent.com/rangapv/bash-source/main/s1.sh) >>/dev/null 2>&1
#source /Users/rangapv/bash-source/s1.sh
count=0

goupgrade() {
gargs="$#"
args=("$@")
gover2="$args"

#web1="https://dl.google.com/go/"
web1="https://go.dev/dl/"

wg=$web1$gover2

ssud=`sudo wget "$wg"`
ssuds="$?"
if [[ ($ssuds -ne 0) ]]
then
	echo "Error downloading Binary from the Go repo double check version and re-run"
	exit
fi
`sudo tar -xzf "$gover2"`
se3=$( echo "${gover2}" | awk '{split($0,a,".");print a[1]"."a[2]}')
`sudo rm -Rf /usr/local/go`
smv=`sudo mv ./go /usr/local/`
echo "smv is $smv"

if [[ ( -z "$mac" ) ]]
then
#echo "export GOROOT=/usr/local/go" >> ~/.bashrc
#echo "export PATH=\$GOROOT/bin:\$PATH" >> ~/.bashrc
#echo "export GOPATH=/usr/local/go" >> ~/.bashrc
#echo "export PATH=\$GOPATH/bin:\$PATH" >> ~/.bashrc
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
eval "source ~/.bashrc"
PS1='$ '     
bi=$(source ~/.bashrc)
rbi=$(echo "$?")
if [ $rbi = "0" ]
then
eval "echo GOROOT is $GOROOT"
eval "echo GOPATH is $GOPATH"
fi

elif [[ (! -z "$mac" ) ]]
then

echo "export GOROOT=/usr/local/go" >> ~/.zprofile
echo "export PATH=\$GOROOT/bin:\$PATH" >> ~/.zprofile
echo "export GOPATH=\$(go env GOPATH)" >> ~/.zprofile
echo "export PATH=\$GOPATH/bin:\$PATH" >> ~/.zprofile
eval "source ~/.zprofile"
bi=$(source ~/.zprofile)
rbi="$?"
if [ $rbi = "0" ]
then
eval "echo GOROOT is $GOROOT"
eval "echo GOPATH is $GOPATH"
fi
else
   echo "No sourcing to do"

fi

}


govercheck() {

gflag=0
gov=`which go`
govs="$?"
if [[ ( $govs -eq 0 ) ]]
then
	gflag=1
elif [[ ( $govs -ne 0 ) && ( ! -z $mac ) ]]
then
       echo "No go found in mac"
       versiongo=0
else
       echo "Default install"
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
elif [[ ( $vergos -ne 0 ) ]]
then
        versiongo=0
else
       echo "No defaults"
fi

}

goreqver () {

ver1="$@"
ver2=$( echo "$ver1" | awk '{split($0,a,"."); print a[2]"."a[3]}')
gocs="$ver2"
}

if [ ! -z "$u1" ]
then 
	if [ "$ki" = "ubuntu" ]
	then
   	echo "IT IS UBUNTU"
	fi
        sudo add-apt-repository -y  ppa:gophers/archive
        sudo apt-get -y update
        count=1

elif [ ! -z "$d1" ]
then
	if [ "$ki" = "debian" ]
	then
   	echo "IT IS Debian"
	fi
        sudo apt-get -y update
        count=1

elif [[ ! -z "$r1" || ! -z "$c1" || ! -z "$a1" ]]
then
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
elif [ ! -z "$mac" ]
then
     echo "inside the go install for MAc"
else
echo "The distribution cannot be determined"
fi

nogo=1
versiongo=1

echo "What version of go is required 1.16/1.17/1.18/1.19/1.20.11/1.21.4 ?"
read gover
govercheck
gocs=0
nogo=0

if [[ (( $gover > $versiongo )) ]]
then
   
	
   goreqver "$gover"
	
	
  if [[ ( $nogo -eq 0 ) && ( -z "$mac" ) ]]
  then
     #echo "go1.$gocs.linux-amd64.tar.gz"
     goupgrade go1.$gocs.linux-amd64.tar.gz
     PS1='$ '
     bi=$(source ~/.bashrc)
     rbi=$(echo "$?")
     if [ $rbi = "0" ]
     then
        eval "echo $(go version)"
     fi
  elif [[ ( $nogo -eq 0 ) && (! -z "$mac" ) ]]
  then
     echo "Installing go on MAC"
     goupgrade go1.$gocs.darwin-arm64.tar.gz
  fi
elif [[ (( $gover < $versiongo )) ]]
then
        echo "Go requiremnet is already satisifed Nothing to Install / Upgrade"
        echo "$gov"
	echo "$vergo"
else
   echo "go-version not available"	  
fi
