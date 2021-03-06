
# If you come from bash you might have to change your $PATH.
-handle-add-path $USER_BIN
-handle-add-path $HOME/antigen
-handle-add-path $HOME/.dotnet/tools
-handle-add-path $USER_LOCAL_FRWKS/Python.framework/Versions/Current/bin
-handle-add-path $USER_LOCAL_OPT/gettext/bin
-handle-add-path $USER_LOCAL_OPT/llvm/bin
-handle-add-path $USER_LOCAL_OPT/apr/bin
-handle-add-path $USER_LOCAL_OPT/apr-util/bin
-handle-add-path $USER_LOCAL_OPT/icu4c/bin
-handle-add-path $USER_LOCAL_OPT/icu4c/sbin
-handle-add-path $USER_LOCAL_OPT/libpq/bin
-handle-add-path $USER_LOCAL_OPT/coreutils/libexec/gnubin
-handle-add-path $USER_LOCAL_OPT/sqlite/bin
-handle-add-path $USER_LOCAL_OPT/go/libexec/bin
-handle-add-path $USER_LOCAL_OPT/gnu-tar/libexec/gnubin
-handle-add-path $USER_LOCAL_OPT/libarchive/bin
-handle-add-path $USER_LOCAL_OPT/openssl/bin
-handle-add-path $USER_LOCAL_OPT/gnu-sed/libexec/gnubin
-handle-add-path $(yarn global bin)
-handle-add-path $(go env GOPATH)/bin
-handle-add-path $USER_LOCAL_GO/bin
-handle-add-path $USER_LOCAL_OPT/go/libexec/bin
-handle-add-path $PERL_LOCAL_LIB_ROOT/bin

-handle-add-infopath $USER_SHARE/info

-handle-add-manpath $USER_LOCAL_OPT/gnu-tar/libexec/gnuman
-handle-add-manpath $USER_LOCAL_OPT/gnu-sed/libexec/gnuman
-handle-add-manpath $USER_LOCAL_OPT/coreutils/libexec/gnuman

-handle-add-pkgconfigpath libffi
-handle-add-pkgconfigpath icu4c
-handle-add-pkgconfigpath libpq
-handle-add-pkgconfigpath sqlite
-handle-add-pkgconfigpath libarchive
-handle-add-pkgconfigpath openssl

