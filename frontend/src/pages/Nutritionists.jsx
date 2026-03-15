import { useEffect, useState } from 'react'
import Header from '../components/Header'
import AppointmentModal from '../components/AppointmentModal';
import { useTranslation } from "react-i18next";


function Nutritionists() {
  const { t } = useTranslation();
  const [dados, setDados] = useState([])
  const [openModal, setOpenModal] = useState(false)
  const [paginaAtual, setPaginaAtual] = useState(1);
  const cardsPorPagina = 2;

  const indiceUltimoCard = paginaAtual * cardsPorPagina;
  const indicePrimeiroCard = indiceUltimoCard - cardsPorPagina;
  const dadosPaginados = dados.slice(indicePrimeiroCard, indiceUltimoCard);
  const totalPaginas = Math.ceil(dados.length / cardsPorPagina);

  useEffect(() => {
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
            <div className="grid grid-cols-1 lg:grid-cols-[200px_1fr_1fr_1fr] gap-4">
              
              {/* Grid1 */}
              <div className="p-1">
                <img className="m-3 w-30" src="user.png" />
              </div>
              {/* Grid 2 */}
              <div className="flex flex-col gap-4 p-4">
                  <div className="flex flex-row items-center bg-nutrium-green-darker/30 w-fit rounded-full px-2 gap-2">
                    <i className="py-2 far fa-star text-nutrium-green-darker"></i>
                    <p className="uppercase text-sm text-center font-semibold text-nutrium-green-darker">{item.name}</p>
                  </div>
                  <p className="text-2xl font-semibold text-nutrium-green-darker">{item.name}</p>
                  <div className="flex flex-row gap-1">
                    <p className="text-l text-slate-600">{item.name}</p>
                    &bull;
                    <p className="text-l text-slate-600">{item.name}</p>
                  </div>
              </div>
              {/* Grid 3*/}
              <div className=" p-4"></div>
              {/* Grid 4 */}
              <div className=" p-4">
                <div className="flex flex-col gap-3">
                  <button 
                  onClick={() => {console.log(1); setOpenModal(true)}}
                  className="w-auto rounded-none bg-nutrium-orange/30 text-nutrium-orange py-2 px-6">{t("scheduleAppointment")} </button>
                  <button 
                  onClick={() => {alert("Not implemented")}}
                  className="w-auto rounded-none bg-nutrium-green/30 text-nutrium-green py-2 px-6">{t("website")}</button>
                </div>
              </div>
              {/* Grid 5 */}
              <div className=" p-4"></div>
              {/* Grid 6 */}
              <div className=" p-4">
                <div className="flex columns-2 my-5 ml-5">
                  <i className="fa-solid fa-location-dot text-nutrium-green-darker text-xl"></i>
                  <div className=" flex flex-col gap-4 mx-5 align-text-top">
                    <p className="text-s font-semibold text-nutrium-green-darker">{t("onlineFollowUp")} </p>
                    <p className="text-s text-slate-600">{item.name}</p>
                    <p className="text-s text-slate-600">{item.name}</p>
                  </div>
                </div>
              </div>
              {/* Grid 7 */}
              <div className=" p-4">
                <div className="flex flex-col my-5 ml-5 gap-4">
                  <div className="flex flex-row ml-30 items-center gap-4">
                    <i className="fa-solid fa-suitcase text-nutrium-green-darker text-xl"></i>
                    <p className=" text-s text-slate-600">{t("firstAppointment")}</p>
                  </div>
                  <div className="flex flex-row  ml-30 items-center gap-4">
                    <i className=" fa-regular fa-money-bill-1 text-nutrium-green-darker text-xl"></i>
                    <p className="text-s text-slate-600">{item.name}</p>
                  </div>
                </div>
              </div>
              {/* Grid 8 */}
              <div className=" p-4"></div>
            </div>
          </div>

        ))}
      </>
    )
  };

  return (
    <div className="min-h-screen bg-nutrium-light-grey">
      <Header/>
       <div className="mx-auto px-4 py-12 gap-3 flex items-center bg-nutrium-green-darker">
          <input className="ml-9 placeholder:italic placeholder:text-slate-300 block bg-white w-full border border-slate-300 rounded-md py-3 pl-9 pr-3 shadow-sm focus:outline-none focus:border-sky-500 focus:ring-sky-500 focus:ring-1 sm:text-md" placeholder={t("placeholderNameService")} type="text" name="search" />
          <input className="placeholder:italic placeholder:text-slate-300 block bg-white w-full border border-slate-300 rounded-md py-3 pl-9 pr-3 shadow-sm focus:outline-none focus:border-sky-500 focus:ring-sky-500 focus:ring-1 sm:text-md" placeholder={t("placeholderLocation")} type="text" name="location" />
          <button className="mr-9 rounded-none bg-nutrium-orange text-white py-3 px-6">{t("search")} </button>
        </div>

      <main className="container mx-auto px-5 py-5">
        <GridCards />
        <Pagination />
      </main>
      <AppointmentModal open={openModal} setOpen={setOpenModal} />
    </div>
  )

}

export default Nutritionists