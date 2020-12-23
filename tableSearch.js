const createSearchInputElement = () => {
    const el = document.createElement('input');
    el.classList.add('search-input');
    el.id = 'search-input';
    return el;
}

const tableData = () => {
    const searchData = [];
    const tableEl = document.getElementById('protein_information');
    Array.from(tableEl.children[1].children).forEach(_bodyRowEl => {
        searchData.push(Array.from(_bodyRowEl.children).map(_cellEl => {
            return _cellEl.innerHTML;
        }));
    });
    return searchData;
}

const search = (arr, searchTerm) => {

    if (!searchTerm) return arr;
    
    return arr.filter( _row => {
        return _row.find(_item => _item.toLowerCase().includes(searchTerm.toLowerCase()))
    });
}

const reFreshTable = (data) =>{
    const tableBody = document.getElementById('protein_information').children[1]
    tableBody.innerHTML = '';
    data.forEach(_row => {
        const curRow = document.createElement('tr');
        _row.forEach(_dataItem => {
            const curCell = document.createElement('td');
            curCell.innerText = _dataItem;
            curRow.appendChild(curCell);
        });
        tableBody.appendChild(curRow);
    });
}
const init = () => {
    document.getElementById('search').appendChild(createSearchInputElement());

    const intialTableData = tableData();

    const searchInput = document.getElementById('search-input');
    searchInput.addEventListener('keyup', (e) => {
        reFreshTable(search(intialTableData, e.target.value));

    });
}

init()



