window.addEventListener('load', function() {

    // URLs for Search form get request
    var allSearchURL = "https://archives.albany.edu/search";
    var arclightSearchURL = "https://archives.albany.edu/description/catalog";
    var hyraxSearchURL = "https://archives.albany.edu/catalog";

    //query selector for search form
    var searchForm = document.getElementsByClassName('search-query-form');
    var searchPlaceholder = document.getElementById('params-q');
    var currentSelection = document.getElementById('currentSelection');


    //button query selectors
    var allSearchBtn = document.getElementById('allSearch')
    var arclightBtn = document.getElementById('arclightSearch');
    var hyraxBtn = document.getElementById('hyraxSearch');
    
    var caret = document.createElement("span");
    caret.setAttribute("class", "caret");

    //
    //
    // Event Listeners - Search options change
    //
    //

    //Search all
    allSearchBtn.addEventListener('click', function() {
        searchForm[0].action = allSearchURL;
        searchPlaceholder.placeholder = "Search everything...";
        currentSelection.textContent = "Everything ";
        currentSelection.appendChild(caret)
    });

    //Search Arclight
    arclightBtn.addEventListener('click', function() {
        searchForm[0].action = arclightSearchURL;
        searchPlaceholder.placeholder = "Search all collection records...";
        currentSelection.textContent = "Collections ";
        currentSelection.appendChild(caret)
    });

    //Search Hyrax
    hyraxBtn.addEventListener('click', function() {
        searchForm[0].action = hyraxSearchURL;
        searchPlaceholder.placeholder = "Search only online digital content...";
        currentSelection.textContent = "Digital Selections ";
        currentSelection.appendChild(caret)
    });


}, false);


window.addEventListener('load', function() {
    $('#toggleSearch').click( function() {
        $('#searchSub').addClass('subnavTransition');
        $("#searchSub").toggleClass("fixedSubnav");
        $("#content-wrapper").toggleClass("subnavSpacer");
    } );

    $(window).scroll(function () {
        var top_offset = $(window).scrollTop();
        if (top_offset < 57) {
            $('#searchSub').removeClass('subnavTransition');
            $('#searchSub').removeClass('fixedSubnav');
            $('#content-wrapper').removeClass('subnavSpacer');
         }
    } );
});

