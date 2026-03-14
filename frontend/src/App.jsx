import { useEffect, useState } from 'react'

function App() {
  const [dados, setDados] = useState([])

  const [paginaAtual, setPaginaAtual] = useState(1);
  const cardsPorPagina = 2;

  const indiceUltimoCard = paginaAtual * cardsPorPagina;
  const indicePrimeiroCard = indiceUltimoCard - cardsPorPagina;
  const dadosPaginados = dados.slice(indicePrimeiroCard, indiceUltimoCard);
  const totalPaginas = Math.ceil(dados.length / cardsPorPagina);

  useEffect(() => {
    // Faz o pedido ao backend (Rails)
    fetch('http://localhost:3000/api/v1/districts')
      .then(res => res.json())
      .then(data => setDados(data))
      .catch(err => console.error("Erro:", err))
  }, [])


  function Pagination() {
    return (
      <nav>
        <ul className="flex -space-x-px text-sm">
          <li>
            {/* Botao Previous */}
            <button
              onClick={() => setPaginaAtual(prev => Math.max(prev - 1, 1))}
              disabled={paginaAtual === 1}
              className="flex items-center justify-center text-body bg-neutral-secondary-medium  border-default-medium rounded-s-base w-9 h-9 hover:bg-neutral-tertiary-medium disabled:opacity-50"
            >
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="m15 19-7-7 7-7" />
              </svg>
            </button>
          </li>

          {[...Array(totalPaginas)].map((_, index) => {
            const numPagina = index + 1;
            return (
              <li key={numPagina}>
                <button
                  onClick={() => setPaginaAtual(numPagina)}
                  className={`flex items-center justify-center w-9 h-9 font-medium transition-colors ${paginaAtual === numPagina
                    ? 'bg-nutrium-green-darker/30 text-nutrium-green-darker'
                    : 'bg-white text-slate-600'
                    }`}
                >
                  {numPagina}
                </button>
              </li>
            );
          })}

          <li>
            {/* Botao Next */}
            <button
              onClick={() => setPaginaAtual(prev => Math.min(prev + 1, totalPaginas))}
              disabled={paginaAtual === totalPaginas}
              className="flex items-center justify-center text-slate-600 bg-neutral-secondary-medium rounded-e-base w-9 h-9 hover:bg-neutral-tertiary-medium disabled:opacity-50"
            >
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="m9 5 7 7-7 7" />
              </svg>
            </button>
          </li>
        </ul>
      </nav>
    )
  }

  function GridCards() {
    return (
      <>
        {dadosPaginados.map((item, index) => (

          <div key={index} className="my-5 p-3 rounded-lg bg-gray-50 shadow-sm">
            <div class="grid grid-cols-[100px_1fr_1fr_1fr] gap-4">
              {/* Grid1 */}
              <div class="p-1">
                <img class="m-3 w-30" src="user.png" />
              </div>
              {/* Grid 2 */}
              <div class=" p-4">
                <div class="">
                  <div class="flex flex-row items-center bg-nutrium-green-darker/30 w-fit rounded-full px-2 gap-2">
                    <i class="py-2 far fa-star text-nutrium-green-darker"></i>
                    <p className="uppercase text-sm text-center font-semibold text-nutrium-green-darker">{item.name}</p>
                  </div>
                  <p className="text-2xl font-semibold text-nutrium-green-darker">{item.name}</p>
                  <div class="flex flex-row gap-2">
                    <p className="text-l text-slate-600">{item.name}</p>
                    &bull;
                    <p className="text-l text-slate-600">{item.name}</p>
                  </div>
                </div>
              </div>
              {/* Grid 3*/}
              <div class=" p-4"></div>
              {/* Grid 4 */}
              <div class=" p-4">
                <div class="flex flex-col gap-3">
                  <button class="w-auto rounded-none bg-nutrium-orange/30 text-nutrium-orange py-2 px-6">Schedule Appointment</button>
                  <button class="w-auto rounded-none bg-nutrium-green/30 text-nutrium-green py-2 px-6">Website</button>
                </div>
              </div>
              {/* Grid 5 */}
              <div class=" p-4"></div>
              {/* Grid 6 */}
              <div class=" p-4">
                <div class="flex columns-2 my-5 ml-3">
                  <i class="mt-1 fa-solid fa-location-dot text-nutrium-green-darker text-xl"></i>
                  <div class=" flex flex-col gap-4 mx-3 align-text-top">
                    <p className="text-s font-semibold text-nutrium-green-darker">Online Follow-up</p>
                    <p className="text-s text-slate-600">{item.name}</p>
                    <p className="text-s text-slate-600">{item.name}</p>
                  </div>
                </div>
              </div>
              {/* Grid 7 */}
              <div class=" p-4">
                <div class="flex flex-col my-5 ml-3 gap-4">
                  <div class="flex flex-row items-center gap-2">
                    <i class="mt-1 fa-solid fa-suitcase text-nutrium-green-darker text-xl"></i>
                    <p className=" text-s text-slate-600">First Appointment</p>
                  </div>
                  <div class="flex flex-row items-center gap-2">
                    <i class=" fa-regular fa-money-bill-1 text-nutrium-green-darker text-xl"></i>
                    <p className="text-s text-slate-600">{item.name}</p>
                  </div>
                </div>
              </div>
              {/* Grid 8 */}
              <div class=" p-4"></div>
            </div>
          </div>

        ))}
      </>
    )
  };

  return (
    <div className="min-h-screen bg-nutrium-light-grey">
      <header className="bg-nutrium-green shadow-md">
        <div className="px-4 py-3 flex justify-between items-center">
          <img className="ml-8 w-30" src="nutrium-removebg.png" />
          <div className="mr-10 flex items-right gap-2 text-white">
            <h2 className=" text-sm font-mediumb text-right">
              Are you a nutrition professional? Get to know our software
            </h2>
            <i className="fa-solid fa-arrow-right"></i>
          </div>
        </div>
        <div class="mx-auto px-4 py-12 gap-3 flex items-center bg-nutrium-green-darker">
          <input class="ml-9 placeholder:italic placeholder:text-slate-300 block bg-white w-full border border-slate-300 rounded-md py-3 pl-9 pr-3 shadow-sm focus:outline-none focus:border-sky-500 focus:ring-sky-500 focus:ring-1 sm:text-md" placeholder="Name, Service..." type="text" name="search" />
          <input class="placeholder:italic placeholder:text-slate-300 block bg-white w-full border border-slate-300 rounded-md py-3 pl-9 pr-3 shadow-sm focus:outline-none focus:border-sky-500 focus:ring-sky-500 focus:ring-1 sm:text-md" placeholder="Location..." type="text" name="location" />
          <button class="mr-9 rounded-none bg-nutrium-orange text-white py-3 px-6">Search</button>
        </div>
      </header>

      <main className="container mx-auto px-5 py-5">
        <GridCards />
        <Pagination />
      </main>
    </div>
  )

}

export default App