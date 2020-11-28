function sortTableByColumn(table, column, asc = true){
    const dirModifier= asc ? 1 :-1;
    const tBody= table.children[1];
    const rows = Array.from(tBody.querySelectorAll("tr"));
    

    //sort each row
    
    const sortedRows = rows.sort((a,b) => {
       const aColText = a.querySelector(`td:nth-child(${ column + 1 })`).textContent.trim();
       const bColText = b.querySelector(`td:nth-child(${ column + 1 })`).textContent.trim();

       const NumACol = Number(aColText)
       const NumBCol = Number(bColText)


       const ValidNumbers = !(isNaN(NumACol) && isNaN(NumBCol));
       const NotEmpty = ((aColText != '') && (bColText != ''));

       if (ValidNumbers && NotEmpty) {
        return NumACol > NumBCol ? (1 * dirModifier) : (-1 * dirModifier);
       } else {
        return aColText.toLowerCase() > bColText.toLowerCase() ? (1 * dirModifier) : (-1 * dirModifier);
       }

       

    });


    //remove all existing tr from the table
    while (tBody.firstChild){
        tBody.removeChild(tBody.firstChild);
    }

    //Update table
    tBody.append(...sortedRows);

    //adding direction indicator, ascending or descending
    table.querySelectorAll("th").forEach(th => th.classList.remove("th-sort-asc", "th-sort-desc"));
    table.querySelector(`th:nth-child(${ column + 1})`).classList.toggle("th-sort-asc", asc);
    table.querySelector(`th:nth-child(${ column + 1})`).classList.toggle("th-sort-desc", !asc);
}

const tableEl = document.getElementById('protein_information');

tableEl.querySelectorAll("th").forEach(headerCell => {
    headerCell.addEventListener("click", ()=>{
        const headerIndex = Array.prototype.indexOf.call(headerCell.parentElement.children, headerCell);
        const currentIsAscending = headerCell.classList.contains("th-sort-asc");
        sortTableByColumn(tableEl, headerIndex, !currentIsAscending);
    })
})

//Reference https://www.youtube.com/watch?v=8SL_hM1a0yo




