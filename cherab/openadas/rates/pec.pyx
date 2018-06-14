# Copyright 2014-2017 United Kingdom Atomic Energy Authority
#
# Licensed under the EUPL, Version 1.1 or – as soon they will be approved by the
# European Commission - subsequent versions of the EUPL (the "Licence");
# You may not use this work except in compliance with the Licence.
# You may obtain a copy of the Licence at:
#
# https://joinup.ec.europa.eu/software/page/eupl5
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.
#
# See the Licence for the specific language governing permissions and limitations
# under the Licence.

import numpy as np
cimport numpy as np
import matplotlib.pyplot as plt

from cherab.core.utility.conversion import PhotonToJ


cdef class ImpactExcitationRate(CoreImpactExcitationRate):

    def __init__(self, double wavelength, np.ndarray te, np.ndarray ne, np.ndarray rate, extrapolate=False):
        """
        :param wavelength: Resting wavelength of corresponding emission line in nm.
        :param te: Electron temperature range in eV.
        :param ne: Electron density range in m^-3.
        :param rate: PEC rate in photons.m^3.
        :param extrapolate: Enable extrapolation (default=False).
        """

        # pre-convert data to W m^3 from Photons s^-1 cm^3 prior to interpolation
        rate = PhotonToJ.to(rate, wavelength)

        # store limits of data
        self.density_range = ne.min(), ne.max()
        self.temperature_range = te.min(), te.max()

        # interpolate rate
        self._rate = Interpolate2DCubic(
            ne, te, rate, extrapolate=extrapolate, extrapolation_type="quadratic"
        )

    cpdef double evaluate(self, double density, double temperature) except? -1e999:

        # prevent -ve values (possible if extrapolation enabled)
        return max(0, self._rate.evaluate(density, temperature))


cdef class RecombinationRate(CoreRecombinationRate):

    def __init__(self, double wavelength, np.ndarray te, np.ndarray ne, np.ndarray rate, extrapolate=False):
        """
        :param wavelength: Resting wavelength of corresponding emission line in nm.
        :param te: Electron temperature range in eV.
        :param ne: Electron density range in m^-3.
        :param rate: PEC rate in photons.m^3.
        :param extrapolate: Enable extrapolation (default=False).
        """

        # pre-convert data to W m^3 from Photons s^-1 cm^3 prior to interpolation
        rate = PhotonToJ.to(rate, wavelength)

        # store limits of data
        self.density_range = ne.min(), ne.max()
        self.temperature_range = te.min(), te.max()

        # interpolate rate
        self._rate = Interpolate2DCubic(
            ne, te, rate, extrapolate=extrapolate, extrapolation_type="quadratic"
        )


    cpdef double evaluate(self, double density, double temperature) except? -1e999:

        # prevent -ve values (possible if extrapolation enabled)
        return max(0, self._rate.evaluate(density, temperature))


# cdef class ThermalCXRate(CoreThermalCXRate):
#
#     def __init__(self, double wavelength ,dict rate_data, extrapolate=False):
#         pass
#     cpdef double evaluate(self, double density, double temperature):
#         pass
#
#     def plot(self, density_list=None, x_limit=None, y_limit=None):
#
#         plt.figure()
#         for dens in density_list:
#             rates = [self.__call__(dens, temp) for temp in self._temperature]
#             plt.loglog(self._temperature, rates, label='{:.4G} m$^{{-3}}$'.format(dens))
#
#         if x_limit:
#             plt.xlim(x_limit)
#         if y_limit:
#             plt.ylim(y_limit)
#
#         plt.legend(loc=4)
#         plt.xlabel('Electron Temperature (eV)')
#         plt.ylabel('$PEC$ (m$^3$ s$^{-1}$)')
#         plt.title('Photon emissivity coefficient')