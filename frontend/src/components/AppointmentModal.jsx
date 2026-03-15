import { Dialog, DialogPanel, DialogTitle, DialogBackdrop } from '@headlessui/react';
import { useTranslation } from "react-i18next";

export default function AppointmentModal({ open, setOpen }) {
    const { t } = useTranslation();

    return (
        <Dialog open={open} onClose={() => setOpen(false)} className="relative z-50">
            <DialogBackdrop className="fixed inset-0 bg-black/50 transition-opacity" />

            <div className="fixed inset-0 z-10 w-screen overflow-y-auto flex items-center justify-center p-4">
                <DialogPanel className="w-full max-w-lg transform overflow-hidden rounded-lg bg-white p-8 shadow-xl transition-all">

                    <DialogTitle as="h3" className="text-xl font-bold text-slate-800 border-b pb-4">
                        {t("scheduleAppointment")}
                    </DialogTitle>

                    <form className="mt-6 space-y-5">

                        {/* Nome e Apelido */}
                        <div className="grid grid-cols-2 gap-4">
                            <div className="flex flex-col gap-1">
                                <span className="text-sm font-semibold text-slate-700">{t("firstname")}</span>
                                <input type="text" placeholder="John" className="px-3 py-2 border border-slate-300 rounded-md text-sm focus:ring-2 focus:ring-nutrium-green outline-none" />
                            </div>
                            <div className="flex flex-col gap-1">
                                <span className="text-sm font-semibold text-slate-700">{t("lastName")}</span>
                                <input type="text" placeholder="Doe" className="px-3 py-2 border border-slate-300 rounded-md text-sm focus:ring-2 focus:ring-nutrium-green outline-none" />
                            </div>
                        </div>

                        {/* Email  */}
                        <div className="flex flex-col gap-1">
                            <span className="text-sm font-semibold text-slate-700">{t("email")}</span>
                            <input type="email" placeholder="john@example.com" className="px-3 py-2 border border-slate-300 rounded-md text-sm focus:ring-2 focus:ring-nutrium-green outline-none" />
                        </div>

                        {/* Data e Hora */}
                        <div className="grid grid-cols-2 gap-4">
                            <div className="flex flex-col gap-1">
                                <span className="text-sm font-semibold text-slate-700">{t("date")}</span>
                                <input type="date" className="px-3 py-2 border border-slate-300 rounded-md text-sm focus:ring-2 focus:ring-nutrium-green outline-none" />
                            </div>
                            <div className="flex flex-col gap-1">
                                <span className="text-sm font-semibold text-slate-700">{t("time")}</span>
                                <input type="time" className="px-3 py-2 border border-slate-300 rounded-md text-sm focus:ring-2 focus:ring-nutrium-green outline-none" />
                            </div>
                        </div>

                        {/* Botões */}
                        <div className="mt-8 flex justify-end gap-3 border-t pt-6">
                            <button
                                type="button"
                                onClick={() => setOpen(false)}
                                className="px-4 py-2 text-sm font-medium text-slate-600 hover:text-slate-800"
                            >
                                {t("cancel")}
                            </button>
                            <button
                                type="submit"
                                className="bg-nutrium-green hover:bg-nutrium-green-darker text-white px-6 py-2 rounded-md font-bold text-sm shadow-sm transition-colors"
                            >
                                {t("saveAppointment")}
                            </button>
                        </div>
                    </form>

                </DialogPanel>
            </div>
        </Dialog>
    );
}
