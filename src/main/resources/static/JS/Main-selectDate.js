function openCalendarWithForm(destinationNum, destinationName) {
	    flatpickr("#datePicker", {
	      mode: "range",
	      dateFormat: "Y-m-d",
	      onClose: function(selectedDates, dateStr, instance) {
	        if (selectedDates.length === 2) {
	          const startDate = instance.formatDate(selectedDates[0], "Y-m-d");
	          const endDate = instance.formatDate(selectedDates[1], "Y-m-d");
	
	          document.getElementById("destinationNum").value = destinationNum;
	          document.getElementById("destinationName").value = destinationName;
	          document.getElementById("scheduleStart").value = startDate;
	          document.getElementById("scheduleEnd").value = endDate;
	
	          document.getElementById("calendarForm").submit();
	        }
	      }
	    }).open();
	  }