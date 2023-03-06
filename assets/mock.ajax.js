(function($) {

    $.ajax = function(params) {
        if (params.url === "mobileAPI/GetSitesWithCameraList") {
            params.success(sitesWithCameraList); //return the data you need
        }
    };

})(jQuery);