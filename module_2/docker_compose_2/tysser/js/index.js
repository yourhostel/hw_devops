"use strict";

document.body.innerHTML = '<div class="container">' +
    '<h1 class="caption"> Homework 24 optional minesweeper </h1><div class = "wrapper">' +
    '</div></div>'

const wrapper = document.querySelector('.wrapper')

    // Керує таймером
let startFlag = true,
    // Розмір поля за замовчуванням
    matrix = 5,
    boxPanel = document.createElement('div')

// Панель керування
function creatBoxPanel() {
    wrapper.prepend(boxPanel)
    boxPanel.classList.add('boxPanel')
    let i = 1
    for (; i <= 4; i++) {
        let panel = document.createElement('div')
        panel.classList.add('panel')
        boxPanel.prepend(panel)
        panel.setAttribute('panel', `${i}`)
    }
}

creatBoxPanel()

const start = document.querySelector(`[panel|='1']`)
start.textContent = 'start'

// Таблиця масштабується змінною mat_rix
function creatTable(mat_rix) {
    const table = document.createElement('div')
    table.classList.add('table')
    wrapper.append(table)
    table.style.setProperty(`grid-template-Rows`, `repeat(${mat_rix}, ${1}fr)`)
    table.style.setProperty(`grid-template-columns`, `repeat(${mat_rix}, ${1}fr)`)
    let i = 1
    for (; i <= mat_rix; i++) {
        for (let j = 1; j <= mat_rix; j++) {
            let td = document.createElement('div')
            td.classList.add('td')
            // Записуємо координати в дата атрибут
            table.appendChild(td).dataset.ij = `${i}.${j}`
        }
    }
}

document.querySelector(`[panel|='2']`).innerHTML = '<div id = "ho"></div><div id = "mi"></div><div id = "se"></div>'
document.querySelector(`[panel|='3']`).innerHTML = '<div id = "viewCellOpen">cell open &nbsp 0 /</div><div id = "viewMines"></div>'
document.querySelector(`[panel|='4']`).innerHTML = '<div id = "viewUserFlag">Flag</div><div id = "viewChoiceField">Field</div><div id = "viewChoiceMines">Mines</div>'

const choiceField = document.querySelector('#viewChoiceField'),
      choiceMines = document.querySelector('#viewChoiceMines')
  let field = document.createElement('ul'),
      mines = document.createElement('ul')

// Списки що випадають
function creatList() {
    choiceField.append(field)
    choiceMines.append(mines)
    mines.classList.add('mines')
    field.classList.add('field')
    let i = 5
    for (; i <= 18; i++) {
        let setLi = document.createElement('li')
        field.appendChild(setLi).innerHTML = `${i}`
        if (i <= 9) {
            let setLi = document.createElement('li')
            mines.appendChild(setLi).innerHTML = `1/${i}`
        }
    }
}

creatList()

// Змінні для роботи з відображенням інформації на панелі
let ratioCellsForMines = 6,
    viewMines = 4,
    cellOpen = 0

// Функції для оновлення інформації на панелі
function updateRatio() {
    viewMines = Math.floor(matrix ** 2 / ratioCellsForMines)
    document.querySelector('#viewMines').innerHTML = `mines &nbsp &nbsp &nbsp &nbsp ${+viewMines}`
}

function updateCell() {
    document.querySelector('#viewCellOpen').innerHTML = `cell open &nbsp ${cellOpen} / ${matrix ** 2 - Math.floor(matrix ** 2 / ratioCellsForMines)}`
}

// Oб'єкт функцій для роботи з селекторами
const q = {
    fieldOpen: () => {
        field.style.opacity = '1';
        field.style.zIndex = '5'
    },
    // Показуємо або приховуємо при натисканні
    fieldClose: () => {
        field.style.opacity = '0';
        field.style.zIndex = '-1'
    },
    minesOpen: () => {
        mines.style.opacity = '1';
        mines.style.zIndex = '5'
    },
    minesClose: () => {
        mines.style.opacity = '0';
        mines.style.zIndex = '-1'
    },
    // Перемикач використовується і для розміру полів і для співвідношення комірки/міни
    trigger: (open, close, loc) => {
        q.minesClose()
        q.fieldClose()
        loc.addEventListener('click', (e) => {
            if (e.target.tagName === 'DIV') {
                open()
            } else {
                close()
            }
        })
    },
    //доробляємо роботу перемикача якщо клацнули не по селектору
    triggerZero: function () {
        wrapper.addEventListener('click', (e) => {
            if (!((e.target.getAttribute('id') === 'viewChoiceField') || (e.target.getAttribute('id') === 'viewChoiceMines'))) {
                q.fieldClose()
                q.minesClose()
            }
        })
    },
    // Селектор використовується і для розміру полів і для співвідношення комірки/міни
    selector: function (loc, bool) {
        // Зчитує значення передає змінним, зупиняє гру видаляє таблицю створює нову
        loc.querySelectorAll('li').forEach((e) => {
            e.addEventListener('click', (e) => {
                if (bool) {
                    matrix = +e.target.textContent
                    removeWin()
                    removeTable()
                    startFlag = true
                    start.textContent = 'start'
                    creatTable(matrix)
                    updateRatio()
                } else {
                    ratioCellsForMines = +e.target.textContent.substring(2, 3)
                    removeWin()
                    removeTable()
                    startFlag = true
                    start.textContent = 'start'
                    creatTable(matrix)
                    updateRatio()
                }
            })
        })
    }
}

// Покаже при старті кількість мін за замовчуванням
updateRatio()

q.trigger(q.fieldOpen, q.fieldClose, choiceField)
q.trigger(q.minesOpen, q.minesClose, choiceMines)
q.selector(field, true)
q.selector(mines, false)
q.triggerZero()

function timer() {
          // елемент для секунд
    const se = document.getElementById("se"),
          // елемент для хвилин
          mi = document.getElementById("mi"),
          // елемент для годин
          ho = document.getElementById("ho");
      let seconds = 0, minutes = 0, hours = 0;
          // Ідентифікатор для можливості зупинки таймера
      let idTimeout;

    function secPlus() {
        // якщо true, зупиняємо таймер
        if (startFlag) {
            // очищуємо localStorage, видаляємо збережений час
            localStorage.removeItem("timer");
            // Записуємо поточний час таймера перед скиданням
            localStorage.setItem("timer", `${ho.textContent}:${mi.textContent}:${se.textContent}`);
            // Скидуємо значення таймера
            [seconds, minutes, hours] = [0, 0, 0];
            // Оновлюємо відображення таймера
            updateDisplay();
            // Зупиняємо таймер
            clearTimeout(idTimeout);
            // Виходимо з функції, щоб не продовжувати відлік
            return;
        }

        // Логіка таймера, якщо startFlag false
        seconds++;
        if (seconds === 60) { seconds = 0; minutes++; }
        if (minutes === 60) { minutes = 0; hours++; }
        // Оновлюємо відображення таймера
        updateDisplay();
        // Плануємо наступний виклик
        idTimeout = setTimeout(secPlus, 1000);
    }

    // Функція для оновлення відображення
    function updateDisplay() {
        se.textContent = String(seconds).padStart(2, '0');
        mi.textContent = `:${String(minutes).padStart(2, '0')}:`;
        ho.textContent = String(hours).padStart(2, '0');
    }

    secPlus(); // Запуск таймера
}

timer();

// Повертає елемент матриці
function e(i, j) {
    return document.querySelector(`.table div[data-ij="${i}.${j}"]`);
}

// Рандомайзер
function getRandomInt(max, min) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return (Math.floor(Math.random() * (max - min + 1)) + min)
}

function setMines() {
    let minesSet = 0;
    while (minesSet < Math.floor(matrix ** 2 / ratioCellsForMines)) {
        let a = getRandomInt(matrix, 1);
        let b = getRandomInt(matrix, 1);
        let cell = e(a, b);
        if (!cell.getAttribute('mines')) {
            cell.setAttribute('mines', '1');
            minesSet++;
        }
    }
}

function digitalAroundMines() {
    for (let o = 0; o < matrix ** 2; o++) {
        let cell = document.querySelectorAll('.td')[o];
        let attr = cell.getAttribute('data-ij');
        let [a, b] = attr.split(".").map(Number);

        if (cell.getAttribute('mines') === '1') {
            // Перевіряємо 8 сусідніх клітин навколо кожної міни
            for (let dx = -1; dx <= 1; dx++) {
                for (let dy = -1; dy <= 1; dy++) {
                    if (dx === 0 && dy === 0) continue; // Пропускаємо саму міну

                    let neighbor = e(a + dx, b + dy);
                    if (neighbor && !neighbor.hasAttribute('mines')) {
                        // Збільшуємо лічильник сусіда, якщо це не міна
                        let count = parseInt(neighbor.textContent) || 0;
                        neighbor.textContent = count + 1;
                    }
                }
            }
        }
    }
}

function removeTable() {
    if (document.querySelector('.table')) {
        document.querySelector('.table').remove()
    }
}

function removeWin() {
    if (document.querySelector('.won')) {
        document.querySelector('.won').remove()
    }
}

function setBlack() {
    document.querySelectorAll('.td').forEach((element) => {
        element.classList.add('black')
    })
}

function removeBlack() {
    document.querySelectorAll('.td').forEach((element) => {
        element.classList.remove('black')
    })
}

function win(lost = false) {
    if (lost || cellOpen === (matrix ** 2 - Math.floor(matrix ** 2 / ratioCellsForMines))) {
        startFlag = true
        removeBlack()
        let won = document.createElement('div')
        wrapper.appendChild(won).classList.add('won')
        if (cellOpen === (matrix ** 2 - Math.floor(matrix ** 2 / ratioCellsForMines))) {
            won.innerHTML = '<p class ="p"> ви виграли !</p>'
            let ht = 1,
                id = setInterval(() => {
                    ht++
                    if (ht > 10) clearInterval(id)
                    document.querySelector('p').style.color = 'red'
                    setTimeout(() => {
                        document.querySelector('p').style.color = 'black'
                    }, 150)
                }, 300)
        } else {
            won.innerHTML = '<p> ви програли !</p>'
        }
    }
}

start.addEventListener('click', (event) => {
    if (event.target.textContent === 'start') {
        // Клік старт
        removeTable()
        removeWin()
        start.textContent = 'finish'
        creatTable(matrix)
        startFlag = false
        cellOpen = 0
        setBlack()
        setMines()
        timer()
        digitalAroundMines()
    } else if (event.target.textContent === 'finish') {
        // Клік фініш
        start.textContent = 'start'
        removeWin()
        startFlag = true
        removeBlack()
    }
})

// Клік по полю
document.querySelector('.wrapper').addEventListener('click', (event) => {
    if (event.target.getAttribute('mines')) {
        // Якщо міна
        start.textContent = 'start'
        if (!startFlag) {
            win(true)
        }
        startFlag = true
        removeBlack()
    } else if (event.target.hasAttribute('data-ij')) {
        // якщо не міна
        let attr = event.target.getAttribute('data-ij'),
            a = +attr.split(".")[0], b = +attr.split(".")[1];
        openFieldZeros(a, b)
        cellOpen = 0
        document.querySelectorAll('.td').forEach((e) => {
            if (!e.classList.contains('black'))
                cellOpen++
            updateCell()
            if (!startFlag) {
                win()
            }
        })
    }
})

function openFieldZeros(i, j) {
        // Перевірка на прапор
  const checkGf = (i, j) => !e(i, j).getAttribute('flag'),
        // Установка прапора захисту від переповнення стека
        sf = (i, j) => e(i, j).setAttribute('flag', '1'),
        // Перевірка на цифру
        dig = (i, j) => e(i, j).textContent.length === 1,
        // Відкриття
        open = (i, j) => e(i, j).classList.remove('black'),
        // Перевіряє наявність міни
        gMines = (i, j) => e(i, j).getAttribute('mines') === '1',
        // Перевіряє, чи комірка в межах поля
        checkOpen = (i, j) => i >= 1 && i <= matrix && j >= 1 && j <= matrix;

    // Рекурсивне відкриття сусідніх осередків
    function openAround(i, j) {
        for (let y = -1; y <= 1; y++) {
            for (let x = -1; x <= 1; x++) {
                let newI = i + y, newJ = j + x;
                // Перевіряє межі і відсутність міни
                if (checkOpen(newI, newJ) && !gMines(newI, newJ)) {
                    open(newI, newJ);
                    // Якщо немає прапора і цифри, рекурсивно відкриває далі
                    if (checkGf(newI, newJ) && !dig(newI, newJ)) {
                        sf(newI, newJ);
                        setTimeout(() => openAround(newI, newJ), 300);
                    }
                }
            }
        }
    }

    if (dig(i, j)) {
        open(i, j);
    } else {
        openAround(i, j);
    }
}

// Версія оптимізована.
// Перша версія: https://gitlab.com/yourhostel.ua/homework-js/-/blob/main/homework24_optional_minesweeper/js/index.js


