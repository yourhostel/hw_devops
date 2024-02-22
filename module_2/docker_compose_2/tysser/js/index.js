"use strict";

    document.body.innerHTML = '<div class="container">' +
        '<h1 class="caption"> Homework 24 optional minesweeper </h1><div class = "wrapper">' +
        '</div></div>'

   const wrapper = document.querySelector('.wrapper')

   let  startFlag = true,  //керує таймером
        matrix = 5,        //розмір поля за замовчуванням
        boxPanel = document.createElement('div')

function creatBoxPanel(){     //панель керування
    wrapper.prepend(boxPanel)
    boxPanel.classList.add('boxPanel')
    let i = 1
    for (; i <= 4; i++) {
        let panel = document.createElement('div')
        panel.classList.add('panel')
        boxPanel.prepend(panel)
        panel.setAttribute('panel',`${i}`)
    }
}

creatBoxPanel()

const start = document.querySelector(`[panel|='1']`)
start.textContent ='start'

function creatTable(mat_rix) {          //таблиця масштабується змінною
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
                table.appendChild(td).dataset.ij = `${i}.${j}`  //не створював двовимірний масив, записував координати в дата атрибут
            }
        }
    }

/*creatTable(matrix)*/

    document.querySelector(`[panel|='2']`).innerHTML= '<div id = "ho"></div><div id = "mi"></div><div id = "se"></div>'
    document.querySelector(`[panel|='3']`).innerHTML= '<div id = "viewCellOpen">cell open &nbsp 0 /</div><div id = "viewMines"></div>'
    document.querySelector(`[panel|='4']`).innerHTML= '<div id = "viewUserFlag">Flag</div><div id = "viewChoiceField">Field</div><div id = "viewChoiceMines">Mines</div>'

const choiceField = document.querySelector('#viewChoiceField'),
      choiceMines = document.querySelector('#viewChoiceMines')
  let field = document.createElement('ul'),
      mines = document.createElement('ul')

function creatList(){          //робимо списки, що випадають
    choiceField.append(field)
    choiceMines.append(mines)
    mines.classList.add('mines')
    field.classList.add('field')
    let i = 5
    for (; i <= 18; i++) {
        let   setLi = document.createElement('li')
        field.appendChild(setLi).innerHTML = `${i}`
        if(i <= 9){
            let   setLi = document.createElement('li')
            mines.appendChild(setLi).innerHTML = `1/${i}`
        }
    }
}

creatList()

let ratioCellsForMines = 6,  //змінні для роботи з відображенням інформації на панелі
    viewMines = 4,
    cellOpen = 0
                                                                  //функції для оновлення інформації на панелі
function updateRatio(){
viewMines = Math.floor(matrix**2/ratioCellsForMines)
document.querySelector('#viewMines').innerHTML = `mines &nbsp &nbsp &nbsp &nbsp ${+viewMines}`
}

function updateCell(){
    document.querySelector('#viewCellOpen').innerHTML = `cell open &nbsp ${cellOpen} / ${matrix ** 2 - Math.floor(matrix ** 2 / ratioCellsForMines)}`
}

const     q = {                                        //об'єкт функцій для роботи з селекторами
    fieldOpen:() => {field.style.opacity = '1'; field.style.zIndex = '5'},        //показуємо або приховуємо при натисканні
    fieldClose:() => {field.style.opacity = '0'; field.style.zIndex = '-1'},
    minesOpen:() => {mines.style.opacity = '1'; mines.style.zIndex = '5'},
    minesClose:() => {mines.style.opacity = '0'; mines.style.zIndex = '-1'},     //не згоден що має бути 1/6 тому зробив селектор і для вибору співвідношення
    trigger:(open,close,loc) =>{                           //перемикач використовується і для розміру полів і для співвідношення комірки/міни
        q.minesClose()
        q.fieldClose()
        loc.addEventListener('click',  (e) =>{
            if(e.target.tagName === 'DIV'){
                open()
            }else{
                close()
            }
        })},
    triggerZero:function (){                         //доробляємо роботу перемикача якщо клацнули не по селектору
        wrapper.addEventListener('click',(e) => {
        if (!((e.target.getAttribute('id') === 'viewChoiceField') || (e.target.getAttribute('id') === 'viewChoiceMines'))){
            q.fieldClose()
            q.minesClose()
        }
    })
    },
    selector:function (loc,bool){             //селектор використовується і для розміру полів і для співвідношення комірки/міни
        loc.querySelectorAll('li').forEach((e) =>{     //зчитує значення передає змінним, зупиняє гру видаляє таблицю створює нову
            e.addEventListener('click',(e) =>{
                if(bool){
                    matrix =  +e.target.textContent
                    removeWin()
                    removeTable()
                    startFlag = true
                    start.textContent = 'start'
                    creatTable(matrix)
                    updateRatio()
                }else{
                    ratioCellsForMines = +e.target.textContent.substring(2,3)
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

updateRatio() //покаже при старті кількість мін за замовчуванням

q.trigger(q.fieldOpen,q.fieldClose,choiceField)
q.trigger(q.minesOpen,q.minesClose,choiceMines)
q.selector(field,true)
q.selector(mines,false)
q.triggerZero()

    function timer(){  //той же рекурсивний таймер, що використовував раніше в інших завданнях
        const se = document.getElementById("se"), mi = document.getElementById("mi"), ho = document.getElementById("ho");
        let seconds = 0,minutes = 0,hours = 0
        function secPlus(s= 0) {
        let    idTimeout = setTimeout(() => {
                if(startFlag) {                             //якщо false нічого не зберігаємо таймер цокає
                    localStorage.removeItem("timer")     //true таймер зупинився, очистили localStorage, записали нові значення
                    localStorage.setItem("timer", `${se.textContent}${mi.textContent}${ho.textContent}`)
                    seconds = 0; minutes = 0; hours = 0                       //очистили змінні
                    seconds = localStorage.getItem("timer").substring(0,2) //перезаписали нові значення для показу результату до наступного старту
                    minutes = localStorage.getItem("timer").substring(3,5)
                    hours = localStorage.getItem("timer").substring(7,8)
                }
                if (seconds === 60){minutes++ ;seconds = 0}
                if (minutes === 60){hours++ ; minutes = 0}
                (hours.toString().length < 2) ? ho.textContent =`0${hours}`: ho.textContent =`${hours}`;
                (minutes.toString().length < 2) ? mi.textContent =`:0${minutes}:`: mi.textContent =`:${minutes}:`;
                (seconds.toString().length < 2) ? se.textContent =`0${seconds}`: se.textContent =`${seconds}`;
                ++seconds
                secPlus(s + 1);
            }, 1000)
            if(startFlag) {                         //якщо true зупиняємо таймер
                clearTimeout(idTimeout)
            }
        }
        secPlus()
    }

    function e(i,j){                                                         //повертає елемент матриці
        return document.querySelector('.table').querySelector(`div[data-ij*="${i}.${j}"]`)
    }

    function getRandomInt(max,min) {     //рандомайзер з mozilla.org
        min = Math.ceil(min);
        max = Math.floor(max);
        return (Math.floor(Math.random() * (max - min + 1)) + min)
    }

    function setMines(){           //розкидаємо міни згідно з поточними значеннями змінних
        for(let i = 0; i < Math.floor(matrix**2/ratioCellsForMines);){
            let a = getRandomInt(matrix,1)      //рандомно створюємо координати та поміщаємо туди міну
            let b = getRandomInt(matrix,1)
            if(!(+e(a ,b).getAttribute('mines'))) { //контролюємо кількість виданих мін
                i++
            }
            e(a ,b).setAttribute('mines','1')
        }
    }

    function digitalAroundMines(){                                          //обходить осередки та обкидає міни цифрами
        for(let o = 0; o < matrix**2; o++){            //функція наочно демонструє свою роботу не використовував (forEach) і розписав координати обходу
            let attr = document.querySelectorAll('.td')[o].getAttribute('data-ij'),
            a = +attr.split(".")[0],b = +attr.split(".")[1],
                i,j                     //координати поточного осередку, що перевіряється
      const z = {
                0:(i,j) => {
                    if(!(+e(a,b).hasAttribute('mines'))){
                        if(!(e(i,j) === null) && +e(i,j).hasAttribute('mines')){
                            let k = +e(a,b).textContent;    //при знаходженні міни біля осередку, що перевіряється, збільшує його значення на один
                            k++;
                            e(a,b).textContent = `${k}`
                        }
                    }
                },
                1:() => { i = a - 1; j = b - 1;z[0](i,j)},        //кожна координата викликає перевірку z[0](i,j)
                2:() => { i = a - 1;           z[0](i,b)},
                3:() => { i = a - 1; j = b + 1;z[0](i,j)},
                4:() => {            j = b - 1;z[0](a,j)},
                5:() => {            j = b + 1;z[0](a,j)},
                6:() => { i = a + 1; j = b - 1;z[0](i,j)},
                7:() => { i = a + 1;           z[0](i,b)},
                8:() => { i = a + 1; j = b + 1;z[0](i,j)},
       }
            for(let i = 1; i < 9;i++){                            //по черзі викликаємо кожну координату
                z[i]()
            }
        }
    }

function removeTable(){if(document.querySelector('.table')){document.querySelector('.table').remove()}}
function removeWin(){if(document.querySelector('.won')){document.querySelector('.won').remove()}}
function setBlack(){document.querySelectorAll('.td').forEach((element) => {element.classList.add('black')})}
function removeBlack(){document.querySelectorAll('.td').forEach((element) => {element.classList.remove('black')})}
function win(lost = false){
       if(lost || cellOpen === (matrix ** 2 - Math.floor(matrix ** 2 / ratioCellsForMines))) {
          startFlag = true
           removeBlack()
               let won = document.createElement('div')
                  wrapper.appendChild(won).classList.add('won')
               if (cellOpen === (matrix ** 2 - Math.floor(matrix ** 2 / ratioCellsForMines))){
                   won.innerHTML = '<p class ="p"> ви виграли !</p>'
                   let ht = 1,
                       id = setInterval(()=>{
                           ht++
                           if(ht > 10)clearInterval(id)
                           document.querySelector('p').style.color = 'red'
                           setTimeout(()=>{document.querySelector('p').style.color = 'black'},150)
                       },300)
      } else {
       won.innerHTML = '<p> ви програли !</p>'
     }
   }
}

start.addEventListener('click', (event) => {
    if(event.target.textContent === 'start'){                  //клик старт
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
    }else if(event.target.textContent === 'finish'){             //клик финиш
        start.textContent = 'start'
        removeWin()
         startFlag = true
           removeBlack()
     }
})

    document.querySelector('.wrapper').addEventListener('click', (event) => {  //клік по полю
        if(event.target.getAttribute('mines')){          //якщо міна
            start.textContent = 'start'
            if(!startFlag){win(true)}
               startFlag = true
                 removeBlack()
        }else if(event.target.hasAttribute('data-ij')){      // якщо не міна
            let attr = event.target.getAttribute('data-ij'),
                a = +attr.split(".")[0],b = +attr.split(".")[1];
                   openFieldZeros(a,b)
                      cellOpen = 0
                         document.querySelectorAll('.td').forEach((e) =>{
                           if(!e.classList.contains('black'))
                               cellOpen++
                                 updateCell()
                             if(!startFlag){win()}
            })
        }
    })

function openFieldZeros(i,j) {
    const checkGf = (i,j) => {return !e(i, j).getAttribute('flag');},   //перевірка на флаг
          sf = (i,j) => {e(i,j).setAttribute('flag','1')},         //Встановлення прапора захист від переповнення стеку
          dig = (i,j) => {return e(i, j).textContent.length === 1},                  //перевірка на цифру
          open = (i,j) => {e(i,j).classList.remove('black')},                    //відкриття
          gMines = (i,j) => {return e(i, j).getAttribute('mines') === '1'},
          checkOpen = (i,j) => {return i >= 1 && i <= matrix && j >= 1 && j <= matrix;}

    if(dig(i,j)){
        open(i,j);
    }else{
        function openAround(i,j){
           i--; j--;  const a = 3, b = 3;            //i--; j-- правий верхній кут квадрата 3Х3  якщо не задати цей параметр рекурсія поширюватиметься лише у південно-східному напрямку
            for (let y = 0; y < a; y++){           //обстрілюємо квадрат
                for (let x = 0; x < b; x++){          //відкриваємо поки все відкривається або поки не провалимося в рекурсію
                    if(checkOpen(i,j) && !gMines(i,j)){   //перевірка на межу периметра та відсутність міни
                        open(i,j);                             //відкриваємо комірку
                        if(checkGf(i,j) && !dig(i,j)){            //немає міни, у межах поля, немає цифри, немає маркера - яма для рекурсії
                            sf(i,j);                           //маркуємо, щоб більше не провалиться
                            setTimeout((i,j) =>{openAround(i,j)},300,i,j)//вхід до рекурсії
                           }
                         }
                       j++
                     }
                   i++
                j = j - b; //так як j глобальна - компенсуємо зайве зростання j віднімаючи число ітерацій вкладеного циклу
             }
          }
      openAround(i,j)
    }
}


