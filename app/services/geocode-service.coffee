geocoder = require 'geocoder'

class GeocodeService
  @geoCoordinates: (place, callback)->
    geocoder.geocode place, (err, data)->
      console.log 'data: ', data
      location = data?.results?[0]?.geometry?.location
      lat = location?.lat
      lng = location?.lng
      console.log 'lat lng: ', { lat, lng }
      callback err, { lat, lng }

  @geoAddress: ({lat, lng}, callback)->
    geocoder.reverseGeocode lat, lng, (err, data)->
      console.log data
      address =
        display: data?.results?[0]?.formatted_address
        number: 0
        street: null
        city: null
        state: null
        zip: null
        country: null
      console.log 'location: ', results
      callback err, { lat, lng }

module.exports = GeocodeService