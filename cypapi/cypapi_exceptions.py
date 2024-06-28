class CypapiEinval(Exception):
    """Invalid argument."""

class CypapiEnomem(Exception):
    """Insufficient memory."""

class CypapiEsys(Exception):
    """A system or C library call failed, please check errno."""

class CypapiEcmp(Exception):
    """Not supported by component"""

class CypapiEsbstr(Exception):
    """Substrate returned an error, usually the result of an unimplemented
    feature."""

class CypapiEclost(Exception):
    """Access to the counters was lost or interrupted."""

class CypapiEbug(Exception):
    """Internal error, please send email to the developers."""

class CypapiEnoevnt(Exception):
    """Hardware event does not exist."""

class CypapiEcnflct(Exception):
    """Hardware event exists, but cannot be counted due to counter resource 
    limitations."""

class CypapiEnotrun(Exception):
    """No events or event sets are currently not counting."""

class CypapiEisrun(Exception):
    """Event Set is currently running."""

class CypapiEnoevst(Exception):
    """No such event set available."""

class CypapiEnotpreset(Exception):
    """Event is not a valid preset."""

class CypapiEnocntr(Exception):
    """Hardware does not support performance counters."""

class CypapiEmisc(Exception):
    """Unknown error code."""

class CypapiEperm(Exception):
    """You lack the necessary permissions."""

class CypapiEnoinit(Exception):
    """PAPI hasn't been initialized yet."""

class CypapiEnocmp(Exception):
    """Component index isn't set."""

class CypapiEnosupp(Exception):
    """Not supported."""

class CypapiEnoimpl(Exception):
    """Not implemented."""

class CypapiEbuf(Exception):
    """Buffer size exceeded"""

class CypapiEinvalDom(Exception):
    """EventSet domain is not uspported for the operation."""

class CypapiEattr(Exception):
    """Invalid or missing event attributes."""

class CypapiEcount(Exception):
    """Too many events or attributes."""

class CypapiEcombo(Exception):
    """Bad combination of features."""

class CypapiEcmpDisabled(Exception):
    """Component containing event is disabled."""

class CypapiEdelayInit(Exception):
    """Delayed initialization component."""

class CypapiEmulpass(Exception):
    """Event exists, but cannot be counted due to multiple passes required by
    hardware."""

# dictionary to be used to raise custom exception based on PAPI error code
_exceptions_for_cypapi = {
   -1: CypapiEinval('Invalid argument (PAPI_EINVAL -1).'),
   -2: CypapiEnomem('Insufficient memory (PAPI_ENOMEM -2).'),
   -3: CypapiEsys('A system or C library call failed (PAPI_ESYS -3).'),
   -4: CypapiEcmp('Not supported by component (PAPI_ECMP -4).'),
   #-5: CypapiEsbstr('Substrate returned an error, usually the result of an unimplemented feature.')
   -5: CypapiEclost('Access to the counters was lost or interrupted (PAPI_ECLOST -5).'),
   -6: CypapiEbug('Internal error, please send mail to the developers (PAPI_EBUG -6).'),
   -7: CypapiEnoevnt('Hardware event does not exist (PAPI_ENOEVNT -7).'),
   -8: CypapiEcnflct('Hardware event exists, but cannot be counted due to counter resource limitations (PAPI_ECNFLCT -8).'),
   -9: CypapiEnotrun('No events or event sets are currently not counting (PAPI_ENOTRUN -9).'),
   -10: CypapiEisrun('Event set is currently running (PAPI_EISRUN -10).'),
   -11: CypapiEnoevst('No such event set available (PAPI_ENOEVST -11).'),
   -12: CypapiEnotpreset('Event is not a valid preset (PAPI_ENOTPRESET -12).'),
   -13: CypapiEnocntr('Hardware does not support performance counters (PAPI_ENOCNTR -13).'),
   -14: CypapiEmisc('Unknown error code (PAPI_EMISC -14).'),
   -15: CypapiEperm('You lack the necessary permissions (PAPI_EPERM -15).'),
   -16: CypapiEnoinit('Cypapi has not been properly initialized with linked PAPI build (PAPI_ENOINIT -16).'),
   -17: CypapiEnocmp('Component index is not set (PAPI_ENOCMP -17).'),
   -18: CypapiEnosupp('Not supported (PAPI_ENOSUPP -18).'),
   -19: CypapiEnoimpl('Not implemented (PAPI_ENOIMPL -19).'),
   -20: CypapiEbuf('Buffer size exceeded (PAPI_EBUF -20).'),
   -21: CypapiEinvalDom('Event set domain is not suppported for the operation (PAPI_EINVAL_DOM -21).'),
   -22: CypapiEattr('Invalid or missing event attributes (PAPI_EATTR -22).'),
   -23: CypapiEcount('Too many events or attributes (PAPI_ECOUNT -23).'),
   -24: CypapiEcombo('Bad comination of features (PAPI_ECOMBO -24).'),
   -25: CypapiEcmpDisabled('Component containing event is disabled (PAPI_ECMP_DISABLED -25).'),
   -26: CypapiEdelayInit('Delayed initialization component (PAPI_EDELAY_INIT -26).'),
   -27: CypapiEmulpass('Event exists, but cannot be counted due to multiple passes required by hardware (PAPI_EMULPASS -27).'),
}
