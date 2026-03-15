import { useEffect, useState } from 'react'
import AppointmentDialog from '../components/AppointmentDialog'
import Header from '../components/Header'
import { useTranslation } from "react-i18next";


function Appointments() {
  const { t } = useTranslation();
  const [open, setOpen] = useState(false)
  const [dados, setDados] = useState([])

  const [paginaAtual, setPaginaAtual] = useState(1);
  const cardsPorLinha = 3;

  const indiceUltimoCard = paginaAtual * cardsPorLinha;
  const indicePrimeiroCard = indiceUltimoCard - cardsPorLinha;
  const dadosPaginados = dados.slice(indicePrimeiroCard, indiceUltimoCard);
  const totalPaginas = Math.ceil(dados.length / cardsPorLinha);

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
              className={`flex items-center justify-center w-9 h-9 font-medium transition-colors bg-white '}`}
            >
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="m15 19-7-7 7-7" />
              </svg>
            </button>
          </li>
          <li>
            {/* Botao Next */}
            <button
              onClick={() => setPaginaAtual(prev => Math.min(prev + 1, totalPaginas))}
              className={`flex items-center justify-center w-9 h-9 font-medium transition-colors bg-white text-nutrium-green-darker'}`}
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

  function RowCards() {
    return (
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {dadosPaginados.map((item, index) => (
          <div key={index} className=" bg-gray-50 shadow-sm ">
            <div className="grid grid-cols-1 divide-y divide-gray-300">
              <div className="p-3 grid grid-cols-[80px_1fr]">
                <div className="flex justify-center items-center">
                  <img className="w-16 h-16 rounded-full" src="user.png" alt="user" />
                </div>
                <div className="p-4">
                  <p className="font-bold text-slate-500">{item.name}</p>
                  <p className="text-xs text-slate-500"> {t("onlineAppointment")} </p>
                  <div className="flex items-center gap-2 mt-2">
                    <i className="fa-regular fa-calendar text-nutrium-green-darker"></i>
                    <p className='text-slate-500'>{item.name}</p>
                  </div>
                  <div className="flex items-center gap-2 mt-1">
                    <i className="fa-regular fa-clock text-nutrium-green-darker"></i>
                    <p className='text-slate-500'>{item.name}</p>
                  </div>
                </div>
              </div>

              <div className="flex justify-center items-center p-2">
                <button
                  onClick={() => setOpen(true)}
                  className="rounded-md px-2.5 py-1.5 text-sm font-semibold text-nutrium-green-darker inset-ring inset-ring-white/5 hover:bg-white/20"
                >
                  {t("answerRequest")}
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
    );
  }


  return (
    <div className="min-h-screen bg-nutrium-light-grey">
      <Header/>
      <main className="container mx-auto px-5 py-5">
        <div className='flex flex-row justify-between items-center'>
          <div className='flex-col'>
            <p className="text-xl text-slate-500">{t("pendingRequests")}</p>
            <p className="text-xs text-slate-500">{t("pendingRequestsMessage")}</p>
          </div>
          <div className=''>
            <Pagination />
          </div>


        </div>

        <div className="grid grid-rows-1  gap-4">
          <div className='mt-5'>
            <RowCards onOpenModal={() => setOpen(true)} />
          </div>
        </div>
        <AppointmentDialog open={open} setOpen={setOpen} />
      </main>
    </div>
  )

}

export default Appointments 