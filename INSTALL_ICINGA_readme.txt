set a 2GB la ram sinon "out of memory" et la compilation est kill lors de l'installation de icinga2 ! (bug vu grace a la commande 'dmesg')
-icinga2 web / admin
- net-analyzer/icinga-web
--> si soucis avec perl (confilt de version) appliquer la pommade ou sa brule:
- emerge --tree --verbose --verbose-conflicts --oneshot dev-lang/perl $(qlist -IC 'virtual/perl-*') $(qlist -IC 'dev-perl/*')
- perl-cleaner --all

