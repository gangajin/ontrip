let selectedDatesGlobal = [];
let flatpickrInstance;

function openCalendarWithForm(destinationNum, destinationName) {
  document.getElementById("calendarModal").style.display = "block";
  document.getElementById("calendarOverlay").style.display = "block";
  document.getElementById("confirmBtn").disabled = true; // 초기엔 비활성화

  if (flatpickrInstance) flatpickrInstance.destroy(); // 중복 방지

  flatpickrInstance = flatpickr("#datePicker", {
    mode: "range",
    inline: true,
    showMonths: 2,
    dateFormat: "Y-m-d",
    locale: "ko",
    minDate: "today",
    onChange: function (selectedDates, dateStr, instance) {
      selectedDatesGlobal = selectedDates;

      const confirmBtn = document.getElementById("confirmBtn");

      if (selectedDates.length === 2) {
        const diffTime = Math.abs(selectedDates[1] - selectedDates[0]);
        const diffDays = diffTime / (1000 * 60 * 60 * 24) + 1;

        if (diffDays > 10) {
          alert("여행 일자는 최대 10일까지 선택할 수 있습니다.");
          instance.clear();
          confirmBtn.disabled = true;
        } else {
          confirmBtn.disabled = false;
        }
      } else {
        confirmBtn.disabled = true;
      }
    }
  });


  // 버튼 눌렀을 때 전송
  document.getElementById("confirmBtn").onclick = function () {
    if (selectedDatesGlobal.length === 2) {
      const startDate = flatpickrInstance.formatDate(selectedDatesGlobal[0], "Y-m-d");
      const endDate = flatpickrInstance.formatDate(selectedDatesGlobal[1], "Y-m-d");

      document.getElementById("destinationNum").value = destinationNum;
      document.getElementById("destinationName").value = destinationName;
      document.getElementById("scheduleStart").value = startDate;
      document.getElementById("scheduleEnd").value = endDate;

      // 모달 닫기
      document.getElementById("calendarModal").style.display = "none";
      document.getElementById("calendarOverlay").style.display = "none";

      // 폼 전송
      document.getElementById("calendarForm").submit();
    }
  };
  
  document.getElementById("cancelBtn").onclick = function () {
      document.getElementById("calendarModal").style.display = "none";
      document.getElementById("calendarOverlay").style.display = "none";
    };
  
}

