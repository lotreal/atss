isx86_64() {
    test $(uname -m) == 'x86_64'
}

if isx86_64
then
    echo yes
else
    echo no
fi
